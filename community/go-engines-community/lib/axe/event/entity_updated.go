package event

import (
	"context"
	"errors"
	"fmt"

	"git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/canopsis/entityservice/statecounters"
	"git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/canopsis/rpc"
	"git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/canopsis/types"
	"git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/mongo"
	mongodriver "go.mongodb.org/mongo-driver/mongo"
)

func NewEntityUpdatedProcessor(
	dbClient mongo.DbClient,
	stateCountersService statecounters.StateCountersService,
) Processor {
	return &entityUpdatedProcessor{
		dbClient:             dbClient,
		alarmCollection:      dbClient.Collection(mongo.AlarmMongoCollection),
		entityCollection:     dbClient.Collection(mongo.EntityMongoCollection),
		stateCountersService: stateCountersService,
	}
}

type entityUpdatedProcessor struct {
	dbClient             mongo.DbClient
	alarmCollection      mongo.DbCollection
	entityCollection     mongo.DbCollection
	stateCountersService statecounters.StateCountersService
}

func (p *entityUpdatedProcessor) Process(ctx context.Context, event rpc.AxeEvent) (Result, error) {
	result := Result{}
	if event.Entity == nil {
		return result, nil
	}

	entity := *event.Entity
	var updatedServiceStates map[string]statecounters.UpdatedServicesInfo

	err := p.dbClient.WithTransaction(ctx, func(ctx context.Context) error {
		updatedServiceStates = nil

		alarm := types.Alarm{}
		err := p.alarmCollection.FindOne(ctx, getOpenAlarmMatch(event)).Decode(&alarm)
		if err != nil && !errors.Is(err, mongodriver.ErrNoDocuments) {
			return err
		}

		if alarm.ID == "" {
			updatedServiceStates, err = p.stateCountersService.UpdateServiceCounters(ctx, entity, nil, result.AlarmChange)
		} else {
			updatedServiceStates, err = p.stateCountersService.UpdateServiceCounters(ctx, entity, &alarm, result.AlarmChange)
		}

		return err
	})

	if err != nil {
		return result, err
	}

	for servID, servInfo := range updatedServiceStates {
		err := p.stateCountersService.UpdateServiceState(ctx, servID, servInfo)
		if err != nil {
			return result, fmt.Errorf("failed to update service state: %w", err)
		}
	}

	return result, nil
}
