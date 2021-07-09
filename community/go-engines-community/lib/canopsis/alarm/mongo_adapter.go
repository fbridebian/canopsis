package alarm

import (
	"context"
	"errors"
	"time"

	"git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/canopsis/types"
	"git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/errt"
	libmongo "git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/mongo"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

const (
	AlarmCollectionName = libmongo.AlarmMongoCollection
)

const bulkMaxSize = 10000

type mongoAdapter struct {
	mainDbCollection     libmongo.DbCollection
	resolvedDbCollection libmongo.DbCollection
	archivedDbCollection libmongo.DbCollection
}

func NewAdapter(dbClient libmongo.DbClient) Adapter {
	return &mongoAdapter{
		mainDbCollection:     dbClient.Collection(AlarmCollectionName),
		resolvedDbCollection: dbClient.Collection(libmongo.ResolvedAlarmMongoCollection),
		archivedDbCollection: dbClient.Collection(libmongo.ArchivedAlarmMongoCollection),
	}
}

func (a mongoAdapter) Insert(ctx context.Context, alarm types.Alarm) error {
	_, err := a.mainDbCollection.InsertOne(ctx, alarm)
	if err != nil {
		return err
	}

	return nil
}

func (a mongoAdapter) Update(ctx context.Context, alarm types.Alarm) error {
	res, err := a.mainDbCollection.UpdateOne(ctx, bson.M{"_id": alarm.ID}, bson.M{"$set": alarm})
	if err != nil {
		return err
	}

	if res.ModifiedCount == 0 {
		return errors.New("alarm not modified")
	}

	return nil
}

func (a mongoAdapter) PartialUpdateOpen(ctx context.Context, alarm *types.Alarm) error {
	update := alarm.GetUpdate()
	if len(update) == 0 {
		return nil
	}

	res, err := a.mainDbCollection.UpdateOne(ctx, bson.M{
		"_id": alarm.ID,
		"$or": []bson.M{
			{"v.resolved": nil},
			{"v.resolved": bson.M{"$exists": false}},
		},
	}, update)
	if err != nil {
		return err
	}

	if res.MatchedCount > 0 && res.ModifiedCount > 0 {
		alarm.CleanUpdate()
	}

	return nil
}

func (a mongoAdapter) GetAlarmsByID(ctx context.Context, id string) ([]types.Alarm, error) {
	return a.getAlarms(ctx, bson.M{"d": id})
}

func (a mongoAdapter) GetAlarmsWithCancelMark(ctx context.Context) ([]types.Alarm, error) {
	return a.getAlarms(ctx, bson.M{
		"v.canceled": bson.M{"$ne": nil},
		"$or": []bson.M{
			{"v.resolved": nil},
			{"v.resolved": bson.M{"$exists": false}},
		},
	})
}

func (a mongoAdapter) GetAlarmsWithDoneMark(ctx context.Context) ([]types.Alarm, error) {
	return a.getAlarms(ctx, bson.M{
		"v.done": bson.M{"$ne": nil},
		"$or": []bson.M{
			{"v.resolved": nil},
			{"v.resolved": bson.M{"$exists": false}},
		},
	})
}

func (a mongoAdapter) GetAlarmsWithSnoozeMark(ctx context.Context) ([]types.Alarm, error) {
	return a.getAlarms(ctx, bson.M{
		"v.snooze": bson.M{"$ne": nil},
		"$or": []bson.M{
			{"v.resolved": nil},
			{"v.resolved": bson.M{"$exists": false}},
		},
	})
}

func (a mongoAdapter) GetAlarmsWithFlappingStatus(ctx context.Context) ([]types.Alarm, error) {
	return a.getAlarms(ctx, bson.M{
		"v.status.val": types.AlarmStatusFlapping,
		"$or": []bson.M{
			{"v.resolved": nil},
			{"v.resolved": bson.M{"$exists": false}},
		},
	})
}

func (a mongoAdapter) GetAllOpenedResourceAlarmsByComponent(ctx context.Context, component string) ([]types.AlarmWithEntity, error) {
	req := bson.M{
		"v.component":  component,
		"v.resource":   bson.M{"$exists": true},
		"v.status.val": bson.M{"$ne": 0},
		"v.meta":       bson.M{"$exists": false},
		"$or": []bson.M{
			{"v.resolved": nil},
			{"v.resolved": bson.M{"$exists": false}},
		},
	}

	return a.getAlarmsWithEntity(ctx, req)
}

func (a mongoAdapter) GetUnacknowledgedAlarmsByComponent(ctx context.Context, component string) ([]types.Alarm, error) {
	return a.getAlarms(ctx, bson.M{
		"v.component": component,
		"v.meta":      bson.M{"$exists": false},
		"$or": []bson.M{
			{"v.resolved": nil},
			{"v.resolved": bson.M{"$exists": false}},
		},
		"v.ack": nil,
	})
}

func (a mongoAdapter) GetAlarmsWithoutTicketByComponent(ctx context.Context, component string) ([]types.Alarm, error) {
	return a.getAlarms(ctx, bson.M{
		"v.component": component,
		"v.meta":      bson.M{"$exists": false},
		"$or": []bson.M{
			{"v.resolved": nil},
			{"v.resolved": bson.M{"$exists": false}},
		},
		"v.ticket": nil,
	})
}

func (a mongoAdapter) GetOpenedAlarmByAlarmId(ctx context.Context, id string) (types.Alarm, error) {
	return a.getAlarmWithErr(ctx, bson.M{
		"_id": id,
		"$or": []bson.M{
			{"v.resolved": nil},
			{"v.resolved": bson.M{"$exists": false}},
		},
	})
}

func (a mongoAdapter) GetOpenedAlarm(ctx context.Context, connector, connectorName, id string) (types.Alarm, error) {
	return a.getAlarmWithErr(ctx, bson.M{
		"d":                id,
		"v.connector":      connector,
		"v.connector_name": connectorName,
		"$or": []bson.M{
			{"v.resolved": nil},
			{"v.resolved": bson.M{"$exists": false}},
		},
	})
}

func (a mongoAdapter) GetOpenedMetaAlarm(ctx context.Context, ruleId string, valuePath string) (types.Alarm, error) {
	al := types.Alarm{}
	query := bson.M{
		"v.meta": ruleId,
		"$or": []bson.M{
			{"v.resolved": nil},
			{"v.resolved": bson.M{"$exists": false}},
		},
	}

	if valuePath != "" {
		query["v.meta_value_path"] = valuePath
	}

	err := a.mainDbCollection.FindOne(ctx, query, options.FindOne().SetSort(bson.M{"v.creation_date": -1})).Decode(&al)
	if err != nil {
		if err == mongo.ErrNoDocuments {
			return al, errt.NewNotFound(err)
		}

		return al, err
	}

	al.Value.Transform()
	return al, nil
}

func (a mongoAdapter) GetLastAlarm(ctx context.Context, connector, connectorName, id string) (types.Alarm, error) {
	alarm := types.Alarm{}
	query := bson.M{
		"d":                id,
		"v.connector":      connector,
		"v.connector_name": connectorName,
	}
	err := a.mainDbCollection.FindOne(ctx, query, options.FindOne().SetSort(bson.M{"v.creation_date": -1})).Decode(&alarm)
	if err != nil {
		if err == mongo.ErrNoDocuments {
			return alarm, errt.NewNotFound(err)
		}

		return alarm, err
	}

	alarm.Value.Transform()
	return alarm, nil
}

func (a mongoAdapter) GetUnresolved(ctx context.Context) ([]types.Alarm, error) {
	return a.getAlarms(ctx, bson.M{"v.resolved": nil})
}

// GetOpenedAlarmsByIDs gets ongoing alarms related the provided entity ids
func (a mongoAdapter) GetOpenedAlarmsByIDs(ctx context.Context, ids []string, alarms *[]types.Alarm) error {
	var err error
	*alarms, err = a.getAlarms(ctx, bson.M{
		"d":          bson.M{"$in": ids},
		"v.resolved": bson.M{"$in": []interface{}{"", nil}},
	})

	return err
}

func (a mongoAdapter) GetOpenedAlarmsWithEntityByIDs(ctx context.Context, ids []string, alarms *[]types.AlarmWithEntity) error {
	filter := bson.M{
		"d":          bson.M{"$in": ids},
		"v.resolved": bson.M{"$in": bson.A{"", nil}},
	}

	var err error
	*alarms, err = a.getAlarmsWithEntity(ctx, filter)

	return err
}

func (a mongoAdapter) GetCountOpenedAlarmsByIDs(ctx context.Context, ids []string) (int64, error) {
	return a.getAlarmsCount(ctx, bson.M{
		"d":          bson.M{"$in": ids},
		"v.resolved": bson.M{"$in": []interface{}{"", nil}},
	})
}

// GetOpenedAlarmsByAlarmIDs gets ongoing alarms related the provided alarm ids
func (a mongoAdapter) GetOpenedAlarmsByAlarmIDs(ctx context.Context, ids []string, alarms *[]types.Alarm) error {
	var err error
	*alarms, err = a.getAlarms(ctx, bson.M{
		"_id":        bson.M{"$in": ids},
		"v.resolved": bson.M{"$in": bson.A{"", nil}},
	})

	return err
}

func (a mongoAdapter) GetOpenedAlarmsWithEntityByAlarmIDs(ctx context.Context, ids []string, alarms *[]types.AlarmWithEntity) error {
	filter := bson.M{
		"_id":        bson.M{"$in": ids},
		"v.resolved": bson.M{"$in": bson.A{"", nil}},
	}

	var err error
	*alarms, err = a.getAlarmsWithEntity(ctx, filter)

	return err

}

func (a mongoAdapter) MassUpdate(ctx context.Context, alarms []types.Alarm, notUpdateResolved bool) error {
	if len(alarms) == 0 {
		return nil
	}

	models := make([]mongo.WriteModel, len(alarms))

	for i, alarm := range alarms {
		filter := bson.M{"_id": alarm.ID}
		if notUpdateResolved {
			filter["v.resolved"] = bson.M{"$in": []interface{}{"", nil}}
		}

		models[i] = mongo.NewUpdateOneModel().
			SetFilter(filter).
			SetUpdate(bson.M{"$set": alarm})
	}

	_, err := a.mainDbCollection.BulkWrite(ctx, models)
	if err != nil {
		return err
	}

	return nil
}

func (a mongoAdapter) MassPartialUpdateOpen(ctx context.Context, updatedAlarm *types.Alarm, alarmID []string) error {
	update := updatedAlarm.GetUpdate()
	if len(update) == 0 {
		return nil
	}

	res, err := a.mainDbCollection.UpdateMany(ctx, bson.M{
		"_id": bson.M{"$in": alarmID},
		"$or": []bson.M{
			{"v.resolved": nil},
			{"v.resolved": bson.M{"$exists": false}},
		},
	}, update)
	if err != nil {
		return err
	}

	if res.MatchedCount > 0 && res.ModifiedCount > 0 {
		updatedAlarm.CleanUpdate()
	}

	return nil
}

func (a mongoAdapter) GetOpenedAlarmsWithLastDatesBefore(
	ctx context.Context,
	time types.CpsTime,
) (libmongo.Cursor, error) {
	return a.mainDbCollection.Aggregate(ctx, []bson.M{
		{"$match": bson.M{
			"v.status.val": bson.M{"$ne": types.AlarmStatusNoEvents},
			"v.resolved":   nil,
			"$or": []bson.M{
				{"v.last_update_date": bson.M{"$lte": time}},
				{"v.last_event_date": bson.M{"$lte": time}},
			},
		}},
		{"$project": bson.M{
			"alarm": "$$ROOT",
			"_id":   0,
		}},
		{"$lookup": bson.M{
			"from":         libmongo.EntityMongoCollection,
			"localField":   "alarm.d",
			"foreignField": "_id",
			"as":           "entity",
		}},
		{"$unwind": "$entity"},
		{"$match": bson.M{
			"entity.enabled":              true,
			"entity.last_idle_rule_apply": nil,
			"entity.type": bson.M{"$in": []string{
				types.EntityTypeConnector,
				types.EntityTypeComponent,
				types.EntityTypeResource,
			}},
		}},
	})
}

func (a mongoAdapter) GetOpenedAlarmsByConnectorIdleRules(ctx context.Context) ([]types.Alarm, error) {
	cursor, err := a.mainDbCollection.Aggregate(ctx, []bson.M{
		{"$match": bson.M{
			"v.state.val":  bson.M{"$ne": types.AlarmStateOK},
			"v.status.val": types.AlarmStatusNoEvents,
			"v.resolved":   nil,
		}},
		{"$lookup": bson.M{
			"from":         libmongo.EntityMongoCollection,
			"localField":   "d",
			"foreignField": "_id",
			"as":           "entity",
		}},
		{"$unwind": "$entity"},
		{"$match": bson.M{"entity.type": types.EntityTypeConnector}},
		{"$match": bson.M{"$expr": bson.M{
			"$gt": bson.A{"$entity.last_event_date", "$v.status.t"},
		}}},
	})

	if err != nil {
		return nil, err
	}

	var alarms []types.Alarm
	err = cursor.All(ctx, &alarms)
	if err != nil {
		return nil, err
	}

	return alarms, nil
}

func (a mongoAdapter) CountResolvedAlarm(ctx context.Context, entityIDs []string) (int, error) {
	res, err := a.getAlarmsCount(ctx, bson.M{
		"d":          bson.M{"$in": entityIDs},
		"v.resolved": bson.M{"$exists": true},
	})

	return int(res), err
}

func (a mongoAdapter) GetLastAlarmByEntityID(ctx context.Context, entityID string) (*types.Alarm, error) {
	cursor, err := a.mainDbCollection.Find(ctx, bson.M{"d": entityID}, options.Find().SetSort(bson.M{"t": -1}))
	if err != nil {
		return nil, err
	}

	defer cursor.Close(ctx)

	if cursor.Next(ctx) {
		alarm := &types.Alarm{}
		err := cursor.Decode(alarm)
		if err != nil {
			return nil, err
		}

		return alarm, nil
	}

	resolvedCursor, err := a.resolvedDbCollection.Find(ctx, bson.M{"d": entityID}, options.Find().SetSort(bson.M{"t": -1}))
	if err != nil {
		return nil, err
	}

	defer resolvedCursor.Close(ctx)

	if resolvedCursor.Next(ctx) {
		alarm := &types.Alarm{}
		err := resolvedCursor.Decode(alarm)
		if err != nil {
			return nil, err
		}

		return alarm, nil
	}

	return nil, nil
}

func (a mongoAdapter) getAlarmsWithEntity(ctx context.Context, filter bson.M) ([]types.AlarmWithEntity, error) {
	cursor, err := a.mainDbCollection.Aggregate(ctx, []bson.M{
		{"$match": filter},
		{"$project": bson.M{
			"alarm": "$$ROOT",
			"_id":   0,
		}},
		{"$lookup": bson.M{
			"from":         libmongo.EntityMongoCollection,
			"localField":   "alarm.d",
			"foreignField": "_id",
			"as":           "entity",
		}},
		{"$unwind": "$entity"},
	})

	if err != nil {
		return nil, err
	}

	defer cursor.Close(ctx)

	var alarmsWithEntity []types.AlarmWithEntity
	err = cursor.All(ctx, &alarmsWithEntity)
	if err != nil {
		return nil, err
	}

	return alarmsWithEntity, nil
}

func (a mongoAdapter) getAlarms(ctx context.Context, filter bson.M) ([]types.Alarm, error) {
	cursor, err := a.mainDbCollection.Find(ctx, filter)
	if err != nil {
		return nil, err
	}

	alarms := make([]types.Alarm, 0)
	err = cursor.All(ctx, &alarms)
	if err != nil {
		return nil, err
	}

	return alarms, nil
}

func (a mongoAdapter) getAlarmsCount(ctx context.Context, filter bson.M) (int64, error) {
	return a.mainDbCollection.CountDocuments(ctx, filter)
}

func (a mongoAdapter) getAlarmWithErr(ctx context.Context, filter bson.M) (types.Alarm, error) {
	alarm := types.Alarm{}
	err := a.mainDbCollection.FindOne(ctx, filter).Decode(&alarm)
	if err != nil {
		if err == mongo.ErrNoDocuments {
			return alarm, errt.NewNotFound(err)
		}

		return alarm, err
	}

	alarm.Value.Transform()

	return alarm, nil
}

func (a mongoAdapter) DeleteResolvedAlarms(ctx context.Context, duration time.Duration) error {
	_, err := a.mainDbCollection.DeleteMany(ctx, bson.M{
		"v.resolved": bson.M{"$lte": time.Now().Unix() - int64(duration.Seconds())},
	})

	return err
}

func (a mongoAdapter) DeleteArchivedResolvedAlarms(ctx context.Context, duration time.Duration) (int64, error) {
	return a.archivedDbCollection.DeleteMany(ctx, bson.M{
		"v.resolved": bson.M{"$lte": time.Now().Unix() - int64(duration.Seconds())},
	})
}

func (a *mongoAdapter) CopyAlarmToResolvedCollection(ctx context.Context, alarm types.Alarm) error {
	_, err := a.resolvedDbCollection.UpdateOne(
		ctx,
		bson.M{"_id": alarm.ID},
		bson.M{"$set": alarm},
		options.Update().SetUpsert(true),
	)

	return err
}

func (a *mongoAdapter) ArchiveResolvedAlarms(ctx context.Context, duration time.Duration) (int64, error) {
	writeModels := make([]mongo.WriteModel, 0, bulkMaxSize)
	archivedIds := make([]string, 0, bulkMaxSize)

	cursor, err := a.resolvedDbCollection.Find(ctx, bson.M{
		"v.resolved": bson.M{"$lte": time.Now().Unix() - int64(duration.Seconds())},
	})

	if err != nil {
		return 0, err
	}

	defer cursor.Close(ctx)

	var archived int64

	for cursor.Next(ctx) {
		var alarm types.Alarm
		err := cursor.Decode(&alarm)
		if err != nil {
			return 0, err
		}

		writeModels = append(
			writeModels,
			mongo.NewUpdateOneModel().
				SetFilter(bson.M{"_id": alarm.ID}).
				SetUpdate(bson.M{"$set": alarm}).
				SetUpsert(true),
		)

		archivedIds = append(archivedIds, alarm.ID)

		if len(writeModels) == bulkMaxSize {
			res, err := a.archivedDbCollection.BulkWrite(ctx, writeModels)
			if err != nil {
				return 0, err
			}

			archived = archived + res.UpsertedCount

			_, err = a.resolvedDbCollection.DeleteMany(
				ctx,
				bson.M{"_id": bson.M{"$in": archivedIds}},
			)
			if err != nil {
				return 0, err
			}

			writeModels = writeModels[:0]
			archivedIds = archivedIds[:0]
		}
	}

	if len(writeModels) != 0 {
		res, err := a.archivedDbCollection.BulkWrite(ctx, writeModels)
		if err != nil {
			return 0, err
		}

		archived = archived + res.UpsertedCount

		_, err = a.resolvedDbCollection.DeleteMany(
			ctx,
			bson.M{"_id": bson.M{"$in": archivedIds}},
		)

		if err != nil {
			return 0, err
		}
	}

	return archived, nil
}
