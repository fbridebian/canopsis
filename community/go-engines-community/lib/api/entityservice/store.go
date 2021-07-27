package entityservice

import (
	"context"
	"git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/api/pagination"
	"git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/canopsis/entityservice"
	"git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/canopsis/types"
	"git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/mongo"
	"git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/utils"
	"go.mongodb.org/mongo-driver/bson"
	mongodriver "go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
	"reflect"
	"time"
)

type Store interface {
	GetOneBy(ctx context.Context, id string) (*Response, error)
	GetDependencies(ctx context.Context, id string, query pagination.Query) (*ContextGraphAggregationResult, error)
	GetImpacts(ctx context.Context, id string, query pagination.Query) (*ContextGraphAggregationResult, error)
	Create(ctx context.Context, request CreateRequest) (*Response, error)
	Update(ctx context.Context, request UpdateRequest) (*Response, ServiceChanges, error)
	Delete(ctx context.Context, id string) (bool, *types.Alarm, error)
}

type ServiceChanges struct {
	IsPatternChanged bool
	IsToggled        bool
}

type store struct {
	dbCollection      mongo.DbCollection
	alarmDbCollection mongo.DbCollection
}

func NewStore(db mongo.DbClient) Store {
	return &store{
		dbCollection:      db.Collection(mongo.EntityMongoCollection),
		alarmDbCollection: db.Collection(mongo.AlarmMongoCollection),
	}
}

func (s *store) GetOneBy(ctx context.Context, id string) (*Response, error) {
	cursor, err := s.dbCollection.Aggregate(ctx, []bson.M{
		{"$match": bson.M{"_id": id, "type": types.EntityTypeService}},
		{"$lookup": bson.M{
			"from":         mongo.EntityCategoryMongoCollection,
			"localField":   "category",
			"foreignField": "_id",
			"as":           "category",
		}},
		{"$unwind": bson.M{"path": "$category", "preserveNullAndEmptyArrays": true}},
	})
	if err != nil {
		return nil, err
	}

	if cursor.Next(ctx) {
		res := Response{}
		err := cursor.Decode(&res)
		if err != nil {
			return nil, err
		}

		return &res, nil
	}

	return nil, nil
}

func (s *store) GetDependencies(ctx context.Context, id string, q pagination.Query) (*ContextGraphAggregationResult, error) {
	service := types.Entity{}
	err := s.dbCollection.
		FindOne(ctx, bson.M{"_id": id, "type": types.EntityTypeService}).
		Decode(&service)
	if err != nil {
		if err == mongodriver.ErrNoDocuments {
			return nil, nil
		}
		return nil, err
	}

	pipeline := []bson.M{
		{"$match": bson.M{"_id": bson.M{"$in": service.Depends}}},
		// Find alarms
		{"$project": bson.M{
			"entity": "$$ROOT",
		}},
		{"$lookup": bson.M{
			"from":         mongo.AlarmMongoCollection,
			"localField":   "entity._id",
			"foreignField": "d",
			"as":           "alarm",
		}},
		{"$unwind": bson.M{"path": "$alarm", "preserveNullAndEmptyArrays": true}},
		{"$match": bson.M{"alarm.v.resolved": nil}},
		{"$addFields": bson.M{
			"impact_state": bson.M{"$multiply": bson.A{"$alarm.v.state.val", "$entity.impact_level"}},
		}},
	}
	projectPipeline := []bson.M{
		// Find category
		{"$lookup": bson.M{
			"from":         mongo.EntityCategoryMongoCollection,
			"localField":   "entity.category",
			"foreignField": "_id",
			"as":           "entity.category",
		}},
		{"$unwind": bson.M{"path": "$entity.category", "preserveNullAndEmptyArrays": true}},
		// Find dependencies
		{"$addFields": bson.M{
			"has_dependencies": bson.M{"$and": []bson.M{
				{"$eq": bson.A{"$entity.type", types.EntityTypeService}},
				{"$gt": bson.A{bson.M{"$size": "$entity.depends"}, 0}},
			}},
		}},
	}
	cursor, err := s.dbCollection.Aggregate(ctx, pagination.CreateAggregationPipeline(
		q,
		pipeline,
		bson.M{"$sort": bson.D{{Key: "impact_state", Value: -1}, {Key: "entity._id", Value: 1}}},
		projectPipeline,
	))
	if err != nil {
		return nil, err
	}

	defer cursor.Close(ctx)
	result := &ContextGraphAggregationResult{}

	if cursor.Next(ctx) {
		err = cursor.Decode(result)
		if err != nil {
			return nil, err
		}
	}

	return result, nil
}

func (s *store) GetImpacts(ctx context.Context, id string, q pagination.Query) (*ContextGraphAggregationResult, error) {
	entity := types.Entity{}
	err := s.dbCollection.
		FindOne(ctx, bson.M{"_id": id}).
		Decode(&entity)
	if err != nil {
		if err == mongodriver.ErrNoDocuments {
			return nil, nil
		}
		return nil, err
	}

	pipeline := []bson.M{
		{"$match": bson.M{
			"_id":  bson.M{"$in": entity.Impacts},
			"type": types.EntityTypeService,
		}},
		// Find alarms
		{"$project": bson.M{
			"entity": "$$ROOT",
		}},
		{"$lookup": bson.M{
			"from":         mongo.AlarmMongoCollection,
			"localField":   "entity._id",
			"foreignField": "d",
			"as":           "alarm",
		}},
		{"$unwind": bson.M{"path": "$alarm", "preserveNullAndEmptyArrays": true}},
		{"$match": bson.M{"alarm.v.resolved": nil}},
		{"$addFields": bson.M{
			"impact_state": bson.M{"$multiply": bson.A{"$alarm.v.state.val", "$entity.impact_level"}},
		}},
	}
	projectPipeline := []bson.M{
		// Find category
		{"$lookup": bson.M{
			"from":         mongo.EntityCategoryMongoCollection,
			"localField":   "entity.category",
			"foreignField": "_id",
			"as":           "entity.category",
		}},
		{"$unwind": bson.M{"path": "$entity.category", "preserveNullAndEmptyArrays": true}},
		// Find impacts
		{"$graphLookup": bson.M{
			"from":                    mongo.EntityMongoCollection,
			"startWith":               "$entity.impact",
			"connectFromField":        "impact",
			"connectToField":          "_id",
			"as":                      "service_impacts",
			"restrictSearchWithMatch": bson.M{"type": types.EntityTypeService},
			"maxDepth":                0,
		}},
		{"$addFields": bson.M{
			"has_impacts": bson.M{"$gt": bson.A{bson.M{"$size": "$service_impacts"}, 0}},
		}},
	}
	cursor, err := s.dbCollection.Aggregate(ctx, pagination.CreateAggregationPipeline(
		q,
		pipeline,
		bson.M{"$sort": bson.D{{Key: "impact_state", Value: -1}, {Key: "entity._id", Value: 1}}},
		projectPipeline,
	))
	if err != nil {
		return nil, err
	}

	defer cursor.Close(ctx)
	result := &ContextGraphAggregationResult{}

	if cursor.Next(ctx) {
		err = cursor.Decode(result)
		if err != nil {
			return nil, err
		}
	}

	return result, nil
}

func (s *store) Create(ctx context.Context, request CreateRequest) (*Response, error) {
	entity := entityservice.EntityService{
		Entity: types.Entity{
			ID:            utils.NewID(),
			Name:          request.Name,
			Depends:       []string{},
			Impacts:       []string{},
			EnableHistory: []types.CpsTime{},
			Enabled:       *request.Enabled,
			Infos:         transformInfos(request.EditRequest),
			Type:          types.EntityTypeService,
			Category:      request.Category,
			ImpactLevel:   request.ImpactLevel,
			Created:       types.CpsTime{Time: time.Now()},
		},
		EntityPatterns: request.EntityPatterns,
		OutputTemplate: request.OutputTemplate,
	}

	if request.ID == "" {
		request.ID = utils.NewID()
	}

	entity.ID = request.ID
	_, err := s.dbCollection.InsertOne(ctx, entity)
	if err != nil {
		return nil, err
	}

	return s.GetOneBy(ctx, entity.ID)
}

func (s *store) Update(ctx context.Context, request UpdateRequest) (*Response, ServiceChanges, error) {
	serviceChanges := ServiceChanges{}
	res := s.dbCollection.FindOneAndUpdate(
		ctx,
		bson.M{
			"_id":  request.ID,
			"type": types.EntityTypeService,
		},
		bson.M{"$set": bson.M{
			"name":            request.Name,
			"output_template": request.OutputTemplate,
			"category":        request.Category,
			"impact_level":    request.ImpactLevel,
			"enabled":         request.Enabled,
			"entity_patterns": request.EntityPatterns,
			"infos":           transformInfos(request.EditRequest),
		}},
		options.FindOneAndUpdate().
			SetProjection(bson.M{"enabled": 1, "entity_patterns": 1}).
			SetReturnDocument(options.Before),
	)
	if err := res.Err(); err != nil {
		if err == mongodriver.ErrNoDocuments {
			return nil, serviceChanges, nil
		}

		return nil, serviceChanges, err
	}

	oldValues := &entityservice.EntityService{}
	err := res.Decode(oldValues)
	if err != nil {
		return nil, serviceChanges, err
	}

	serviceChanges.IsToggled = oldValues.Enabled != *request.Enabled
	serviceChanges.IsPatternChanged = !reflect.DeepEqual(oldValues.EntityPatterns, request.EntityPatterns)

	service, err := s.GetOneBy(ctx, request.ID)
	if err != nil {
		return nil, serviceChanges, err
	}

	return service, serviceChanges, nil
}

func (s *store) Delete(ctx context.Context, id string) (bool, *types.Alarm, error) {
	deleted, err := s.dbCollection.DeleteOne(ctx, bson.M{
		"_id":  id,
		"type": types.EntityTypeService,
	})
	if err != nil || deleted == 0 {
		return false, nil, err
	}

	// Delete open alarm.
	var alarm *types.Alarm
	res := s.alarmDbCollection.FindOneAndDelete(ctx, bson.M{"d": id, "v.resolved": nil})
	if err := res.Err(); err == nil {
		alarm = &types.Alarm{}
		err := res.Decode(alarm)
		if err != nil {
			return false, nil, err
		}
	} else if err != mongodriver.ErrNoDocuments {
		return false, nil, err
	}
	// Delete resolved alarms.
	_, err = s.alarmDbCollection.DeleteMany(ctx, bson.M{"d": id})
	if err != nil {
		return false, nil, err
	}

	return true, alarm, nil
}

func transformInfos(request EditRequest) map[string]types.Info {
	infos := make(map[string]types.Info, len(request.Infos))
	for _, v := range request.Infos {
		infos[v.Name] = types.Info{
			Name:        v.Name,
			Description: v.Description,
			Value:       v.Value,
		}
	}

	return infos
}
