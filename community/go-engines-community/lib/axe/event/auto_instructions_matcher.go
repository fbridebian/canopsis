package event

import (
	"context"

	"git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/canopsis/types"
)

type AutoInstructionMatcher interface {
	Load(ctx context.Context) error
	Match(triggers []string, alarmWithEntity types.AlarmWithEntity) (bool, error)
}

type nullAutoInstructionMatcher struct{}

func NewNullAutoInstructionMatcher() AutoInstructionMatcher {
	return &nullAutoInstructionMatcher{}
}

func (_ nullAutoInstructionMatcher) Load(_ context.Context) error {
	return nil
}

func (_ nullAutoInstructionMatcher) Match(_ []string, _ types.AlarmWithEntity) (bool, error) {
	return false, nil
}
