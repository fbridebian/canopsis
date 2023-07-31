package alarm

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"errors"
	"fmt"
	"sync"

	"git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/api/websocket"
	"git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/canopsis/encoding"
	"git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/canopsis/types"
	"git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/mongo"
	"github.com/gin-gonic/gin/binding"
	"github.com/rs/zerolog"
	"go.mongodb.org/mongo-driver/bson"
	mongodriver "go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

type Watcher interface {
	StartWatch(ctx context.Context, connId, userId, roomId string, data any) error
	StartWatchDetails(ctx context.Context, connId, userId, roomId string, data any) error
	StopWatch(ctx context.Context, connId, roomId string) error
}

func NewWatcher(
	client mongo.DbClient,
	hub websocket.Hub,
	store Store,
	encoder encoding.Encoder,
	decoder encoding.Decoder,
	logger zerolog.Logger,
) Watcher {
	return &watcher{
		collection: client.Collection(mongo.AlarmMongoCollection),
		hub:        hub,
		store:      store,
		encoder:    encoder,
		decoder:    decoder,
		logger:     logger,
		streams:    make(map[string]map[string]streamData),
	}
}

// watcher subscribes to MongoDb to watch after changes of alarms.
type watcher struct {
	collection mongo.DbCollection
	hub        websocket.Hub
	store      Store
	encoder    encoding.Encoder
	decoder    encoding.Decoder
	logger     zerolog.Logger

	streamsMx sync.Mutex
	streams   map[string]map[string]streamData
}

type streamData struct {
	connIdsByUserId map[string][]string
	cancel          context.CancelFunc
}

// StartWatch creates a new stream change or adds a connection to an existed one if there is already a stream change with the same request.
func (w *watcher) StartWatch(ctx context.Context, connId, userId, roomId string, data any) error {
	b, err := w.encoder.Encode(data)
	if err != nil {
		return fmt.Errorf("unexpected data type: %w", err)
	}

	k := w.genKey(b)
	streamCtx, streamCancel := context.WithCancel(ctx)
	if !w.newStream(roomId, k, connId, userId, streamCancel) {
		return nil
	}

	var alarmIds []string
	err = w.decoder.Decode(b, &alarmIds)
	if err != nil {
		return fmt.Errorf("unexpected data type: %w", err)
	}

	stream, err := w.collection.Watch(ctx, []bson.M{
		{"$match": bson.M{
			"operationType":   "update",
			"documentKey._id": bson.M{"$in": alarmIds},
		}},
	})
	if err != nil {
		return fmt.Errorf("cannot watch collecton: %w", err)
	}

	go func() {
		defer func() {
			_ = stream.Close(streamCtx)
			streamCancel()
		}()

		for stream.Next(streamCtx) {
			changeEvent := struct {
				DocumentKey struct {
					ID string `bson:"_id"`
				} `bson:"documentKey"`
			}{}
			err = stream.Decode(&changeEvent)
			if err != nil {
				w.logger.Err(err).Msgf("cannot decode alarm")
				continue
			}

			connIdsByUserId := w.getConnIds(roomId, k)
			for userId, connIds := range connIdsByUserId {
				res, err := w.store.GetByID(streamCtx, changeEvent.DocumentKey.ID, userId, true)
				if err != nil {
					w.logger.Err(err).Msgf("cannot get alarm")
					continue
				}
				if res == nil {
					w.logger.Error().Msgf("cannot find alarm")
					continue
				}

				w.hub.SendGroupRoomByConnections(streamCtx, connIds, websocket.RoomAlarmsGroup, roomId, res)
			}
		}
	}()

	return nil
}

// StartWatchDetails creates a new stream change or adds a connection to an existed one if there is already a stream change with the same request.
func (w *watcher) StartWatchDetails(ctx context.Context, connId, userId, roomId string, data any) error {
	b, err := w.encoder.Encode(data)
	if err != nil {
		return fmt.Errorf("unexpected data type: %w", err)
	}

	k := w.genKey(b)
	streamCtx, streamCancel := context.WithCancel(ctx)
	if !w.newStream(roomId, k, connId, userId, streamCancel) {
		return nil
	}

	var request DetailsRequest
	err = w.decoder.Decode(b, &request)
	if err != nil {
		return fmt.Errorf("unexpected data type: %w", err)
	}

	request.Format()
	err = binding.Validator.ValidateStruct(request)
	if err != nil {
		return fmt.Errorf("invalid request: %w", err)
	}

	var alarm types.Alarm
	err = w.collection.FindOne(ctx, bson.M{
		"_id":        request.ID,
		"v.resolved": nil,
	}, options.FindOne().SetProjection(bson.M{"d": 1, "v.meta": 1})).Decode(&alarm)
	if err != nil {
		if errors.Is(err, mongodriver.ErrNoDocuments) {
			return fmt.Errorf("alarm not found")
		}

		return fmt.Errorf("cannot find alarm: %w", err)
	}

	var pipeline []bson.M
	opts := options.ChangeStream()
	if request.Children == nil || request.Children.Page == 0 || alarm.Value.Meta == "" {
		pipeline = []bson.M{
			{"$match": bson.M{
				"operationType":   "update",
				"documentKey._id": request.ID,
			}},
		}
	} else {
		pipeline = []bson.M{
			{"$match": bson.M{"$or": []bson.M{
				{
					"operationType":   "update",
					"documentKey._id": request.ID,
				},
				{
					"operationType":          "update",
					"fullDocument.v.parents": alarm.EntityID,
				},
			}}},
		}
		opts = opts.SetFullDocument(options.UpdateLookup)
	}

	stream, err := w.collection.Watch(ctx, pipeline, opts)
	if err != nil {
		return fmt.Errorf("cannot watch collecton: %w", err)
	}

	go func() {
		defer func() {
			_ = stream.Close(streamCtx)
			streamCancel()
		}()
		for stream.Next(streamCtx) {
			connIdsByUserId := w.getConnIds(roomId, k)
			for userId, connIds := range connIdsByUserId {
				res, err := w.store.GetDetails(streamCtx, request, userId)
				if err != nil {
					w.logger.Err(err).Msgf("cannot get alarm")
					continue
				}

				w.hub.SendGroupRoomByConnections(streamCtx, connIds, websocket.RoomAlarmDetailsGroup, roomId, res)
			}
		}
	}()

	return nil
}

func (w *watcher) StopWatch(_ context.Context, connId, roomId string) error {
	w.streamsMx.Lock()
	defer w.streamsMx.Unlock()

	for k, v := range w.streams[roomId] {
		for userId, connIds := range v.connIdsByUserId {
			index := -1

			for i, streamConnId := range connIds {
				if streamConnId == connId {
					index = i
					break
				}
			}

			if index < 0 {
				continue
			}

			w.streams[roomId][k].connIdsByUserId[userId] = append(connIds[:index], connIds[index+1:]...)
			if len(w.streams[roomId][k].connIdsByUserId[userId]) == 0 {
				delete(w.streams[roomId][k].connIdsByUserId, userId)

				if len(w.streams[roomId][k].connIdsByUserId) == 0 {
					delete(w.streams[roomId], k)
					v.cancel()
				}
			}

			return nil
		}
	}

	return nil
}

func (w *watcher) newStream(roomId, k, connId, userId string, streamCancel context.CancelFunc) bool {
	w.streamsMx.Lock()
	defer w.streamsMx.Unlock()

	if _, ok := w.streams[roomId]; !ok {
		w.streams[roomId] = map[string]streamData{k: {
			connIdsByUserId: map[string][]string{userId: {connId}},
			cancel:          streamCancel,
		}}

		return true
	}

	if _, ok := w.streams[roomId][k]; ok {
		w.streams[roomId][k].connIdsByUserId[userId] = append(w.streams[roomId][k].connIdsByUserId[userId], connId)
		return false
	}

	w.streams[roomId][k] = streamData{
		connIdsByUserId: map[string][]string{userId: {connId}},
		cancel:          streamCancel,
	}

	return true
}

func (w *watcher) getConnIds(roomId, k string) map[string][]string {
	w.streamsMx.Lock()
	defer w.streamsMx.Unlock()

	return w.streams[roomId][k].connIdsByUserId
}

func (w *watcher) genKey(b []byte) string {
	cacheKey := sha256.Sum256(b)
	return hex.EncodeToString(cacheKey[:])
}
