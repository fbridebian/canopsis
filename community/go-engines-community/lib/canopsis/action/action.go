package action

import (
	"encoding/json"
	"fmt"
	"git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/canopsis/eventfilter/pattern"
	"git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/canopsis/types"
	"github.com/mitchellh/mapstructure"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/bsontype"
)

const (
	PriorityField = "priority"
	IdField       = "_id"
)

type Scenario struct {
	ID                   string                  `bson:"_id,omitempty" json:"_id,omitempty"`
	Name                 string                  `bson:"name" json:"name"`
	Author               string                  `bson:"author" json:"author"`
	Enabled              bool                    `bson:"enabled" json:"enabled"`
	DisableDuringPeriods []string                `bson:"disable_during_periods" json:"disable_during_periods"`
	Triggers             []string                `bson:"triggers" json:"triggers"`
	Actions              []Action                `bson:"actions" json:"actions"`
	Priority             int                     `bson:"priority" json:"priority"`
	Delay                *types.DurationWithUnit `bson:"delay" json:"delay"`
	Created              types.CpsTime           `bson:"created,omitempty" json:"created,omitempty"`
	Updated              types.CpsTime           `bson:"updated,omitempty" json:"updated,omitempty"`
}

func (s Scenario) IsTriggered(triggers []string) bool {
	for _, expectedTrigger := range s.Triggers {
		for _, trigger := range triggers {
			if expectedTrigger == trigger {
				return true
			}
		}
	}

	return false
}

// Action represents a canopsis Action on alarms.
type Action struct {
	Type                     string                    `bson:"type" json:"type"`
	Parameters               interface{}               `bson:"parameters,omitempty" json:"parameters,omitempty"` // parameters for the action
	AlarmPatterns            pattern.AlarmPatternList  `bson:"alarm_patterns" json:"alarm_patterns"`
	EntityPatterns           pattern.EntityPatternList `bson:"entity_patterns" json:"entity_patterns"`
	DropScenarioIfNotMatched bool                      `bson:"drop_scenario_if_not_matched" json:"drop_scenario_if_not_matched"`
	EmitTrigger              bool                      `bson:"emit_trigger" json:"emit_trigger"`
}

func (a *Action) UnmarshalBSONValue(_ bsontype.Type, b []byte) error {
	type Alias Action
	var tmp Alias

	err := bson.Unmarshal(b, &tmp)
	if err != nil {
		return err
	}

	*a = Action(tmp)
	a.Parameters = bsonDtoMap(a.Parameters)

	err = a.convertParamsMapToStruct()
	if err != nil {
		return err
	}

	return nil
}

func (a *Action) UnmarshalJSON(b []byte) error {
	type Alias Action
	var tmp Alias

	err := json.Unmarshal(b, &tmp)
	if err != nil {
		return err
	}

	*a = Action(tmp)

	err = a.convertParamsMapToStruct()
	if err != nil {
		return err
	}

	return nil
}

func (a *Action) convertParamsMapToStruct() error {
	switch a.Type {
	case types.ActionTypeAssocTicket:
		params := &types.OperationAssocTicketParameters{}
		err := mapstructure.Decode(a.Parameters, params)
		if err != nil {
			return fmt.Errorf("cannot decode map struct : %v", err)
		}
		a.Parameters = params
	case types.ActionTypeChangeState:
		params := &types.OperationChangeStateParameters{}
		err := mapstructure.Decode(a.Parameters, params)
		if err != nil {
			return fmt.Errorf("cannot decode map struct : %v", err)
		}
		a.Parameters = params
	case types.ActionTypeSnooze:
		params := &types.OperationSnoozeParameters{}
		err := mapstructure.Decode(a.Parameters, params)
		if err != nil {
			return fmt.Errorf("cannot decode map struct : %v", err)
		}
		a.Parameters = params
	case types.ActionTypePbehavior:
		params := &types.ActionPBehaviorParameters{}
		err := mapstructure.Decode(a.Parameters, params)
		if err != nil {
			return fmt.Errorf("cannot decode map struct : %v", err)
		}
		a.Parameters = params
	case types.ActionTypeWebhook:
		params := &types.WebhookParameters{}
		err := mapstructure.Decode(a.Parameters, params)
		if err != nil {
			return fmt.Errorf("cannot decode map struct : %v", err)
		}
		a.Parameters = params
	default:
		params := &types.OperationParameters{}
		err := mapstructure.Decode(a.Parameters, params)
		if err != nil {
			return fmt.Errorf("cannot decode map struct : %v", err)
		}
		a.Parameters = params
	}

	return nil
}

func bsonDtoMap(i interface{}) interface{} {
	if b, ok := i.(bson.D); ok {
		m := b.Map()
		for k := range m {
			if b, ok := m[k].(bson.D); ok {
				m[k] = bsonDtoMap(b)
			}
		}

		return m
	}

	return i
}
