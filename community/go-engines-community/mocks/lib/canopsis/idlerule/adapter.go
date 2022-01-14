// Code generated by MockGen. DO NOT EDIT.
// Source: git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/canopsis/idlerule (interfaces: RuleAdapter)

// Package mock_idlerule is a generated GoMock package.
package mock_idlerule

import (
	context "context"
	reflect "reflect"

	idlerule "git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/canopsis/idlerule"
	gomock "github.com/golang/mock/gomock"
)

// MockRuleAdapter is a mock of RuleAdapter interface.
type MockRuleAdapter struct {
	ctrl     *gomock.Controller
	recorder *MockRuleAdapterMockRecorder
}

// MockRuleAdapterMockRecorder is the mock recorder for MockRuleAdapter.
type MockRuleAdapterMockRecorder struct {
	mock *MockRuleAdapter
}

// NewMockRuleAdapter creates a new mock instance.
func NewMockRuleAdapter(ctrl *gomock.Controller) *MockRuleAdapter {
	mock := &MockRuleAdapter{ctrl: ctrl}
	mock.recorder = &MockRuleAdapterMockRecorder{mock}
	return mock
}

// EXPECT returns an object that allows the caller to indicate expected use.
func (m *MockRuleAdapter) EXPECT() *MockRuleAdapterMockRecorder {
	return m.recorder
}

// GetEnabled mocks base method.
func (m *MockRuleAdapter) GetEnabled(arg0 context.Context) ([]idlerule.Rule, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "GetEnabled", arg0)
	ret0, _ := ret[0].([]idlerule.Rule)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// GetEnabled indicates an expected call of GetEnabled.
func (mr *MockRuleAdapterMockRecorder) GetEnabled(arg0 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "GetEnabled", reflect.TypeOf((*MockRuleAdapter)(nil).GetEnabled), arg0)
}
