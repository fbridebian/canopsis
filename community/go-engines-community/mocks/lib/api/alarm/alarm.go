// Code generated by MockGen. DO NOT EDIT.
// Source: git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/api/alarm (interfaces: Store)

// Package mock_alarm is a generated GoMock package.
package mock_alarm

import (
	context "context"
	reflect "reflect"

	alarm "git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/api/alarm"
	export "git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/api/export"
	link "git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/canopsis/link"
	gomock "github.com/golang/mock/gomock"
)

// MockStore is a mock of Store interface.
type MockStore struct {
	ctrl     *gomock.Controller
	recorder *MockStoreMockRecorder
}

// MockStoreMockRecorder is the mock recorder for MockStore.
type MockStoreMockRecorder struct {
	mock *MockStore
}

// NewMockStore creates a new mock instance.
func NewMockStore(ctrl *gomock.Controller) *MockStore {
	mock := &MockStore{ctrl: ctrl}
	mock.recorder = &MockStoreMockRecorder{mock}
	return mock
}

// EXPECT returns an object that allows the caller to indicate expected use.
func (m *MockStore) EXPECT() *MockStoreMockRecorder {
	return m.recorder
}

// Count mocks base method.
func (m *MockStore) Count(arg0 context.Context, arg1 alarm.FilterRequest) (*alarm.Count, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "Count", arg0, arg1)
	ret0, _ := ret[0].(*alarm.Count)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// Count indicates an expected call of Count.
func (mr *MockStoreMockRecorder) Count(arg0, arg1 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "Count", reflect.TypeOf((*MockStore)(nil).Count), arg0, arg1)
}

// Export mocks base method.
func (m *MockStore) Export(arg0 context.Context, arg1 export.Task) (export.DataCursor, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "Export", arg0, arg1)
	ret0, _ := ret[0].(export.DataCursor)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// Export indicates an expected call of Export.
func (mr *MockStoreMockRecorder) Export(arg0, arg1 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "Export", reflect.TypeOf((*MockStore)(nil).Export), arg0, arg1)
}

// Find mocks base method.
func (m *MockStore) Find(arg0 context.Context, arg1 alarm.ListRequestWithPagination, arg2 string) (*alarm.AggregationResult, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "Find", arg0, arg1, arg2)
	ret0, _ := ret[0].(*alarm.AggregationResult)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// Find indicates an expected call of Find.
func (mr *MockStoreMockRecorder) Find(arg0, arg1, arg2 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "Find", reflect.TypeOf((*MockStore)(nil).Find), arg0, arg1, arg2)
}

// FindByComponent mocks base method.
func (m *MockStore) FindByComponent(arg0 context.Context, arg1 alarm.ListByComponentRequest, arg2 string) (*alarm.AggregationResult, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "FindByComponent", arg0, arg1, arg2)
	ret0, _ := ret[0].(*alarm.AggregationResult)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// FindByComponent indicates an expected call of FindByComponent.
func (mr *MockStoreMockRecorder) FindByComponent(arg0, arg1, arg2 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "FindByComponent", reflect.TypeOf((*MockStore)(nil).FindByComponent), arg0, arg1, arg2)
}

// FindByService mocks base method.
func (m *MockStore) FindByService(arg0 context.Context, arg1 string, arg2 alarm.ListByServiceRequest, arg3 string) (*alarm.AggregationResult, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "FindByService", arg0, arg1, arg2, arg3)
	ret0, _ := ret[0].(*alarm.AggregationResult)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// FindByService indicates an expected call of FindByService.
func (mr *MockStoreMockRecorder) FindByService(arg0, arg1, arg2, arg3 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "FindByService", reflect.TypeOf((*MockStore)(nil).FindByService), arg0, arg1, arg2, arg3)
}

// FindResolved mocks base method.
func (m *MockStore) FindResolved(arg0 context.Context, arg1 alarm.ResolvedListRequest, arg2 string) (*alarm.AggregationResult, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "FindResolved", arg0, arg1, arg2)
	ret0, _ := ret[0].(*alarm.AggregationResult)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// FindResolved indicates an expected call of FindResolved.
func (mr *MockStoreMockRecorder) FindResolved(arg0, arg1, arg2 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "FindResolved", reflect.TypeOf((*MockStore)(nil).FindResolved), arg0, arg1, arg2)
}

// GetAssignedDeclareTicketsMap mocks base method.
func (m *MockStore) GetAssignedDeclareTicketsMap(arg0 context.Context, arg1 []string) (map[string][]alarm.AssignedDeclareTicketRule, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "GetAssignedDeclareTicketsMap", arg0, arg1)
	ret0, _ := ret[0].(map[string][]alarm.AssignedDeclareTicketRule)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// GetAssignedDeclareTicketsMap indicates an expected call of GetAssignedDeclareTicketsMap.
func (mr *MockStoreMockRecorder) GetAssignedDeclareTicketsMap(arg0, arg1 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "GetAssignedDeclareTicketsMap", reflect.TypeOf((*MockStore)(nil).GetAssignedDeclareTicketsMap), arg0, arg1)
}

// GetAssignedInstructionsMap mocks base method.
func (m *MockStore) GetAssignedInstructionsMap(arg0 context.Context, arg1 []string) (map[string][]alarm.AssignedInstruction, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "GetAssignedInstructionsMap", arg0, arg1)
	ret0, _ := ret[0].(map[string][]alarm.AssignedInstruction)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// GetAssignedInstructionsMap indicates an expected call of GetAssignedInstructionsMap.
func (mr *MockStoreMockRecorder) GetAssignedInstructionsMap(arg0, arg1 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "GetAssignedInstructionsMap", reflect.TypeOf((*MockStore)(nil).GetAssignedInstructionsMap), arg0, arg1)
}

// GetByID mocks base method.
func (m *MockStore) GetByID(arg0 context.Context, arg1, arg2 string, arg3 bool) (*alarm.Alarm, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "GetByID", arg0, arg1, arg2, arg3)
	ret0, _ := ret[0].(*alarm.Alarm)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// GetByID indicates an expected call of GetByID.
func (mr *MockStoreMockRecorder) GetByID(arg0, arg1, arg2, arg3 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "GetByID", reflect.TypeOf((*MockStore)(nil).GetByID), arg0, arg1, arg2, arg3)
}

// GetDetails mocks base method.
func (m *MockStore) GetDetails(arg0 context.Context, arg1 alarm.DetailsRequest, arg2 string) (*alarm.Details, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "GetDetails", arg0, arg1, arg2)
	ret0, _ := ret[0].(*alarm.Details)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// GetDetails indicates an expected call of GetDetails.
func (mr *MockStoreMockRecorder) GetDetails(arg0, arg1, arg2 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "GetDetails", reflect.TypeOf((*MockStore)(nil).GetDetails), arg0, arg1, arg2)
}

// GetInstructionExecutionStatuses mocks base method.
func (m *MockStore) GetInstructionExecutionStatuses(arg0 context.Context, arg1 []string, arg2 map[string][]alarm.AssignedInstruction) (map[string]alarm.ExecutionStatus, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "GetInstructionExecutionStatuses", arg0, arg1, arg2)
	ret0, _ := ret[0].(map[string]alarm.ExecutionStatus)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// GetInstructionExecutionStatuses indicates an expected call of GetInstructionExecutionStatuses.
func (mr *MockStoreMockRecorder) GetInstructionExecutionStatuses(arg0, arg1, arg2 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "GetInstructionExecutionStatuses", reflect.TypeOf((*MockStore)(nil).GetInstructionExecutionStatuses), arg0, arg1, arg2)
}

// GetLinks mocks base method.
func (m *MockStore) GetLinks(arg0 context.Context, arg1 string, arg2 []string, arg3 string) ([]link.Link, bool, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "GetLinks", arg0, arg1, arg2, arg3)
	ret0, _ := ret[0].([]link.Link)
	ret1, _ := ret[1].(bool)
	ret2, _ := ret[2].(error)
	return ret0, ret1, ret2
}

// GetLinks indicates an expected call of GetLinks.
func (mr *MockStoreMockRecorder) GetLinks(arg0, arg1, arg2, arg3 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "GetLinks", reflect.TypeOf((*MockStore)(nil).GetLinks), arg0, arg1, arg2, arg3)
}

// GetOpenByEntityID mocks base method.
func (m *MockStore) GetOpenByEntityID(arg0 context.Context, arg1, arg2 string) (*alarm.Alarm, bool, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "GetOpenByEntityID", arg0, arg1, arg2)
	ret0, _ := ret[0].(*alarm.Alarm)
	ret1, _ := ret[1].(bool)
	ret2, _ := ret[2].(error)
	return ret0, ret1, ret2
}

// GetOpenByEntityID indicates an expected call of GetOpenByEntityID.
func (mr *MockStoreMockRecorder) GetOpenByEntityID(arg0, arg1, arg2 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "GetOpenByEntityID", reflect.TypeOf((*MockStore)(nil).GetOpenByEntityID), arg0, arg1, arg2)
}
