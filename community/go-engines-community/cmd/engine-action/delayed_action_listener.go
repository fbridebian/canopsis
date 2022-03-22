package main

import (
	"context"
	libamqp "git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/amqp"
	"git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/canopsis/action"
	"git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/canopsis/encoding"
	"git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/canopsis/types"
	amqp "github.com/rabbitmq/amqp091-go"
	"github.com/rs/zerolog"
	"time"
)

type delayedScenarioListener struct {
	PeriodicalInterval     time.Duration
	DelayedScenarioManager action.DelayedScenarioManager
	AmqpChannel            libamqp.Channel
	Queue                  string
	Encoder                encoding.Encoder
	Logger                 zerolog.Logger
}

func (l *delayedScenarioListener) Listen(ctx context.Context, ch <-chan action.DelayedScenarioTask) {
	for {
		select {
		case <-ctx.Done():
			return
		case task, ok := <-ch:
			if !ok {
				return
			}

			err := l.publishRunDelayedScenarioEvent(task)
			if err != nil {
				l.Logger.Err(err).Msg("cannot send run delayed scenario event")
				continue
			}

			l.Logger.Debug().Str("scenario", task.Scenario.ID).Str("alarm", task.Alarm.ID).Msg("send run delayed scenario event")
		}
	}
}

func (l *delayedScenarioListener) publishRunDelayedScenarioEvent(
	task action.DelayedScenarioTask,
) error {
	event := types.Event{
		EventType:         types.EventTypeRunDelayedScenario,
		Connector:         task.Alarm.Value.Connector,
		ConnectorName:     task.Alarm.Value.ConnectorName,
		Component:         task.Alarm.Value.Component,
		Resource:          task.Alarm.Value.Resource,
		Timestamp:         types.CpsTime{Time: time.Now()},
		Output:            "run delayed scenario",
		Initiator:         types.InitiatorSystem,
		DelayedScenarioID: task.Scenario.ID,
	}
	event.SourceType = event.DetectSourceType()
	body, err := l.Encoder.Encode(event)
	if err != nil {
		l.Logger.Err(err).Msg("cannot encode event")
		return err
	}

	err = l.AmqpChannel.Publish("",
		l.Queue,
		false,
		false,
		amqp.Publishing{
			ContentType:  "application/json",
			Body:         body,
			DeliveryMode: amqp.Persistent,
		},
	)
	if err != nil {
		l.Logger.Err(err).Msg("cannot publish message to amqp channel")
		return err
	}

	return nil
}
