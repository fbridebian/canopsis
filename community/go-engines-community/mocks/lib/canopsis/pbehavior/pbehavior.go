// Code generated by MockGen. DO NOT EDIT.
// Source: git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/canopsis/pbehavior (interfaces: Service,EntityMatcher,ModelProvider,EventManager,ComputedEntityMatcher,Store,EntityTypeResolver)

// Package mock_pbehavior is a generated GoMock package.
package mock_pbehavior

import (
	context "context"
	pbehavior "git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/canopsis/pbehavior"
	types "git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/canopsis/types"
	timespan "git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/timespan"
	gomock "github.com/golang/mock/gomock"
	reflect "reflect"
	time "time"
)

// MockService is a mock of Service interface
type MockService struct {
	ctrl     *gomock.Controller
	recorder *MockServiceMockRecorder
}

// MockServiceMockRecorder is the mock recorder for MockService
type MockServiceMockRecorder struct {
	mock *MockService
}

// NewMockService creates a new mock instance
func NewMockService(ctrl *gomock.Controller) *MockService {
	mock := &MockService{ctrl: ctrl}
	mock.recorder = &MockServiceMockRecorder{mock}
	return mock
}

// EXPECT returns an object that allows the caller to indicate expected use
func (m *MockService) EXPECT() *MockServiceMockRecorder {
	return m.recorder
}

// Compute mocks base method
func (m *MockService) Compute(arg0 context.Context, arg1 timespan.Span) (int, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "Compute", arg0, arg1)
	ret0, _ := ret[0].(int)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// Compute indicates an expected call of Compute
func (mr *MockServiceMockRecorder) Compute(arg0, arg1 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "Compute", reflect.TypeOf((*MockService)(nil).Compute), arg0, arg1)
}

// Recompute mocks base method
func (m *MockService) Recompute(arg0 context.Context) error {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "Recompute", arg0)
	ret0, _ := ret[0].(error)
	return ret0
}

// Recompute indicates an expected call of Recompute
func (mr *MockServiceMockRecorder) Recompute(arg0 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "Recompute", reflect.TypeOf((*MockService)(nil).Recompute), arg0)
}

// RecomputeByID mocks base method
func (m *MockService) RecomputeByID(arg0 context.Context, arg1 string) error {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "RecomputeByID", arg0, arg1)
	ret0, _ := ret[0].(error)
	return ret0
}

// RecomputeByID indicates an expected call of RecomputeByID
func (mr *MockServiceMockRecorder) RecomputeByID(arg0, arg1 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "RecomputeByID", reflect.TypeOf((*MockService)(nil).RecomputeByID), arg0, arg1)
}

// Resolve mocks base method
func (m *MockService) Resolve(arg0 context.Context, arg1 string, arg2 time.Time) (pbehavior.ResolveResult, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "Resolve", arg0, arg1, arg2)
	ret0, _ := ret[0].(pbehavior.ResolveResult)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// Resolve indicates an expected call of Resolve
func (mr *MockServiceMockRecorder) Resolve(arg0, arg1, arg2 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "Resolve", reflect.TypeOf((*MockService)(nil).Resolve), arg0, arg1, arg2)
}

// MockEntityMatcher is a mock of EntityMatcher interface
type MockEntityMatcher struct {
	ctrl     *gomock.Controller
	recorder *MockEntityMatcherMockRecorder
}

// MockEntityMatcherMockRecorder is the mock recorder for MockEntityMatcher
type MockEntityMatcherMockRecorder struct {
	mock *MockEntityMatcher
}

// NewMockEntityMatcher creates a new mock instance
func NewMockEntityMatcher(ctrl *gomock.Controller) *MockEntityMatcher {
	mock := &MockEntityMatcher{ctrl: ctrl}
	mock.recorder = &MockEntityMatcherMockRecorder{mock}
	return mock
}

// EXPECT returns an object that allows the caller to indicate expected use
func (m *MockEntityMatcher) EXPECT() *MockEntityMatcherMockRecorder {
	return m.recorder
}

// MatchAll mocks base method
func (m *MockEntityMatcher) MatchAll(arg0 context.Context, arg1 string, arg2 map[string]string) (map[string]bool, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "MatchAll", arg0, arg1, arg2)
	ret0, _ := ret[0].(map[string]bool)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// MatchAll indicates an expected call of MatchAll
func (mr *MockEntityMatcherMockRecorder) MatchAll(arg0, arg1, arg2 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "MatchAll", reflect.TypeOf((*MockEntityMatcher)(nil).MatchAll), arg0, arg1, arg2)
}

// MockModelProvider is a mock of ModelProvider interface
type MockModelProvider struct {
	ctrl     *gomock.Controller
	recorder *MockModelProviderMockRecorder
}

// MockModelProviderMockRecorder is the mock recorder for MockModelProvider
type MockModelProviderMockRecorder struct {
	mock *MockModelProvider
}

// NewMockModelProvider creates a new mock instance
func NewMockModelProvider(ctrl *gomock.Controller) *MockModelProvider {
	mock := &MockModelProvider{ctrl: ctrl}
	mock.recorder = &MockModelProviderMockRecorder{mock}
	return mock
}

// EXPECT returns an object that allows the caller to indicate expected use
func (m *MockModelProvider) EXPECT() *MockModelProviderMockRecorder {
	return m.recorder
}

// GetEnabledPbehavior mocks base method
func (m *MockModelProvider) GetEnabledPbehavior(arg0 context.Context, arg1 string) (*pbehavior.PBehavior, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "GetEnabledPbehavior", arg0, arg1)
	ret0, _ := ret[0].(*pbehavior.PBehavior)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// GetEnabledPbehavior indicates an expected call of GetEnabledPbehavior
func (mr *MockModelProviderMockRecorder) GetEnabledPbehavior(arg0, arg1 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "GetEnabledPbehavior", reflect.TypeOf((*MockModelProvider)(nil).GetEnabledPbehavior), arg0, arg1)
}

// GetEnabledPbehaviors mocks base method
func (m *MockModelProvider) GetEnabledPbehaviors(arg0 context.Context) (map[string]*pbehavior.PBehavior, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "GetEnabledPbehaviors", arg0)
	ret0, _ := ret[0].(map[string]*pbehavior.PBehavior)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// GetEnabledPbehaviors indicates an expected call of GetEnabledPbehaviors
func (mr *MockModelProviderMockRecorder) GetEnabledPbehaviors(arg0 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "GetEnabledPbehaviors", reflect.TypeOf((*MockModelProvider)(nil).GetEnabledPbehaviors), arg0)
}

// GetExceptions mocks base method
func (m *MockModelProvider) GetExceptions(arg0 context.Context) (map[string]*pbehavior.Exception, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "GetExceptions", arg0)
	ret0, _ := ret[0].(map[string]*pbehavior.Exception)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// GetExceptions indicates an expected call of GetExceptions
func (mr *MockModelProviderMockRecorder) GetExceptions(arg0 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "GetExceptions", reflect.TypeOf((*MockModelProvider)(nil).GetExceptions), arg0)
}

// GetReasons mocks base method
func (m *MockModelProvider) GetReasons(arg0 context.Context) (map[string]*pbehavior.Reason, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "GetReasons", arg0)
	ret0, _ := ret[0].(map[string]*pbehavior.Reason)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// GetReasons indicates an expected call of GetReasons
func (mr *MockModelProviderMockRecorder) GetReasons(arg0 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "GetReasons", reflect.TypeOf((*MockModelProvider)(nil).GetReasons), arg0)
}

// GetTypes mocks base method
func (m *MockModelProvider) GetTypes(arg0 context.Context) (map[string]*pbehavior.Type, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "GetTypes", arg0)
	ret0, _ := ret[0].(map[string]*pbehavior.Type)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// GetTypes indicates an expected call of GetTypes
func (mr *MockModelProviderMockRecorder) GetTypes(arg0 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "GetTypes", reflect.TypeOf((*MockModelProvider)(nil).GetTypes), arg0)
}

// MockEventManager is a mock of EventManager interface
type MockEventManager struct {
	ctrl     *gomock.Controller
	recorder *MockEventManagerMockRecorder
}

// MockEventManagerMockRecorder is the mock recorder for MockEventManager
type MockEventManagerMockRecorder struct {
	mock *MockEventManager
}

// NewMockEventManager creates a new mock instance
func NewMockEventManager(ctrl *gomock.Controller) *MockEventManager {
	mock := &MockEventManager{ctrl: ctrl}
	mock.recorder = &MockEventManagerMockRecorder{mock}
	return mock
}

// EXPECT returns an object that allows the caller to indicate expected use
func (m *MockEventManager) EXPECT() *MockEventManagerMockRecorder {
	return m.recorder
}

// GetEvent mocks base method
func (m *MockEventManager) GetEvent(arg0 pbehavior.ResolveResult, arg1 types.Alarm, arg2 time.Time) types.Event {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "GetEvent", arg0, arg1, arg2)
	ret0, _ := ret[0].(types.Event)
	return ret0
}

// GetEvent indicates an expected call of GetEvent
func (mr *MockEventManagerMockRecorder) GetEvent(arg0, arg1, arg2 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "GetEvent", reflect.TypeOf((*MockEventManager)(nil).GetEvent), arg0, arg1, arg2)
}

// MockComputedEntityMatcher is a mock of ComputedEntityMatcher interface
type MockComputedEntityMatcher struct {
	ctrl     *gomock.Controller
	recorder *MockComputedEntityMatcherMockRecorder
}

// MockComputedEntityMatcherMockRecorder is the mock recorder for MockComputedEntityMatcher
type MockComputedEntityMatcherMockRecorder struct {
	mock *MockComputedEntityMatcher
}

// NewMockComputedEntityMatcher creates a new mock instance
func NewMockComputedEntityMatcher(ctrl *gomock.Controller) *MockComputedEntityMatcher {
	mock := &MockComputedEntityMatcher{ctrl: ctrl}
	mock.recorder = &MockComputedEntityMatcherMockRecorder{mock}
	return mock
}

// EXPECT returns an object that allows the caller to indicate expected use
func (m *MockComputedEntityMatcher) EXPECT() *MockComputedEntityMatcherMockRecorder {
	return m.recorder
}

// LoadAll mocks base method
func (m *MockComputedEntityMatcher) LoadAll(arg0 context.Context, arg1 map[string]string) error {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "LoadAll", arg0, arg1)
	ret0, _ := ret[0].(error)
	return ret0
}

// LoadAll indicates an expected call of LoadAll
func (mr *MockComputedEntityMatcherMockRecorder) LoadAll(arg0, arg1 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "LoadAll", reflect.TypeOf((*MockComputedEntityMatcher)(nil).LoadAll), arg0, arg1)
}

// Match mocks base method
func (m *MockComputedEntityMatcher) Match(arg0 context.Context, arg1 string) ([]string, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "Match", arg0, arg1)
	ret0, _ := ret[0].([]string)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// Match indicates an expected call of Match
func (mr *MockComputedEntityMatcherMockRecorder) Match(arg0, arg1 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "Match", reflect.TypeOf((*MockComputedEntityMatcher)(nil).Match), arg0, arg1)
}

// MatchAll mocks base method
func (m *MockComputedEntityMatcher) MatchAll(arg0 context.Context, arg1 []string) (map[string][]string, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "MatchAll", arg0, arg1)
	ret0, _ := ret[0].(map[string][]string)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// MatchAll indicates an expected call of MatchAll
func (mr *MockComputedEntityMatcherMockRecorder) MatchAll(arg0, arg1 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "MatchAll", reflect.TypeOf((*MockComputedEntityMatcher)(nil).MatchAll), arg0, arg1)
}

// MockStore is a mock of Store interface
type MockStore struct {
	ctrl     *gomock.Controller
	recorder *MockStoreMockRecorder
}

// MockStoreMockRecorder is the mock recorder for MockStore
type MockStoreMockRecorder struct {
	mock *MockStore
}

// NewMockStore creates a new mock instance
func NewMockStore(ctrl *gomock.Controller) *MockStore {
	mock := &MockStore{ctrl: ctrl}
	mock.recorder = &MockStoreMockRecorder{mock}
	return mock
}

// EXPECT returns an object that allows the caller to indicate expected use
func (m *MockStore) EXPECT() *MockStoreMockRecorder {
	return m.recorder
}

// DelComputedPbehavior mocks base method
func (m *MockStore) DelComputedPbehavior(arg0 context.Context, arg1 string) error {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "DelComputedPbehavior", arg0, arg1)
	ret0, _ := ret[0].(error)
	return ret0
}

// DelComputedPbehavior indicates an expected call of DelComputedPbehavior
func (mr *MockStoreMockRecorder) DelComputedPbehavior(arg0, arg1 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "DelComputedPbehavior", reflect.TypeOf((*MockStore)(nil).DelComputedPbehavior), arg0, arg1)
}

// GetComputed mocks base method
func (m *MockStore) GetComputed(arg0 context.Context) (pbehavior.ComputeResult, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "GetComputed", arg0)
	ret0, _ := ret[0].(pbehavior.ComputeResult)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// GetComputed indicates an expected call of GetComputed
func (mr *MockStoreMockRecorder) GetComputed(arg0 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "GetComputed", reflect.TypeOf((*MockStore)(nil).GetComputed), arg0)
}

// GetComputedByIDs mocks base method
func (m *MockStore) GetComputedByIDs(arg0 context.Context, arg1 []string) (pbehavior.ComputeResult, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "GetComputedByIDs", arg0, arg1)
	ret0, _ := ret[0].(pbehavior.ComputeResult)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// GetComputedByIDs indicates an expected call of GetComputedByIDs
func (mr *MockStoreMockRecorder) GetComputedByIDs(arg0, arg1 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "GetComputedByIDs", reflect.TypeOf((*MockStore)(nil).GetComputedByIDs), arg0, arg1)
}

// GetSpan mocks base method
func (m *MockStore) GetSpan(arg0 context.Context) (timespan.Span, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "GetSpan", arg0)
	ret0, _ := ret[0].(timespan.Span)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// GetSpan indicates an expected call of GetSpan
func (mr *MockStoreMockRecorder) GetSpan(arg0 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "GetSpan", reflect.TypeOf((*MockStore)(nil).GetSpan), arg0)
}

// SetComputed mocks base method
func (m *MockStore) SetComputed(arg0 context.Context, arg1 pbehavior.ComputeResult) error {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "SetComputed", arg0, arg1)
	ret0, _ := ret[0].(error)
	return ret0
}

// SetComputed indicates an expected call of SetComputed
func (mr *MockStoreMockRecorder) SetComputed(arg0, arg1 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "SetComputed", reflect.TypeOf((*MockStore)(nil).SetComputed), arg0, arg1)
}

// SetComputedPbehavior mocks base method
func (m *MockStore) SetComputedPbehavior(arg0 context.Context, arg1 string, arg2 pbehavior.ComputedPbehavior) error {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "SetComputedPbehavior", arg0, arg1, arg2)
	ret0, _ := ret[0].(error)
	return ret0
}

// SetComputedPbehavior indicates an expected call of SetComputedPbehavior
func (mr *MockStoreMockRecorder) SetComputedPbehavior(arg0, arg1, arg2 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "SetComputedPbehavior", reflect.TypeOf((*MockStore)(nil).SetComputedPbehavior), arg0, arg1, arg2)
}

// SetSpan mocks base method
func (m *MockStore) SetSpan(arg0 context.Context, arg1 timespan.Span) error {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "SetSpan", arg0, arg1)
	ret0, _ := ret[0].(error)
	return ret0
}

// SetSpan indicates an expected call of SetSpan
func (mr *MockStoreMockRecorder) SetSpan(arg0, arg1 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "SetSpan", reflect.TypeOf((*MockStore)(nil).SetSpan), arg0, arg1)
}

// MockEntityTypeResolver is a mock of EntityTypeResolver interface
type MockEntityTypeResolver struct {
	ctrl     *gomock.Controller
	recorder *MockEntityTypeResolverMockRecorder
}

// MockEntityTypeResolverMockRecorder is the mock recorder for MockEntityTypeResolver
type MockEntityTypeResolverMockRecorder struct {
	mock *MockEntityTypeResolver
}

// NewMockEntityTypeResolver creates a new mock instance
func NewMockEntityTypeResolver(ctrl *gomock.Controller) *MockEntityTypeResolver {
	mock := &MockEntityTypeResolver{ctrl: ctrl}
	mock.recorder = &MockEntityTypeResolverMockRecorder{mock}
	return mock
}

// EXPECT returns an object that allows the caller to indicate expected use
func (m *MockEntityTypeResolver) EXPECT() *MockEntityTypeResolverMockRecorder {
	return m.recorder
}

// GetPbehaviors mocks base method
func (m *MockEntityTypeResolver) GetPbehaviors(arg0 context.Context, arg1 []string, arg2 time.Time) (map[string]pbehavior.ResolveResult, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "GetPbehaviors", arg0, arg1, arg2)
	ret0, _ := ret[0].(map[string]pbehavior.ResolveResult)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// GetPbehaviors indicates an expected call of GetPbehaviors
func (mr *MockEntityTypeResolverMockRecorder) GetPbehaviors(arg0, arg1, arg2 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "GetPbehaviors", reflect.TypeOf((*MockEntityTypeResolver)(nil).GetPbehaviors), arg0, arg1, arg2)
}

// Resolve mocks base method
func (m *MockEntityTypeResolver) Resolve(arg0 context.Context, arg1 string, arg2 time.Time) (pbehavior.ResolveResult, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "Resolve", arg0, arg1, arg2)
	ret0, _ := ret[0].(pbehavior.ResolveResult)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// Resolve indicates an expected call of Resolve
func (mr *MockEntityTypeResolverMockRecorder) Resolve(arg0, arg1, arg2 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "Resolve", reflect.TypeOf((*MockEntityTypeResolver)(nil).Resolve), arg0, arg1, arg2)
}

// ResolveAll mocks base method
func (m *MockEntityTypeResolver) ResolveAll(arg0 context.Context, arg1 []string, arg2 time.Time) (map[string]pbehavior.ResolveResult, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "ResolveAll", arg0, arg1, arg2)
	ret0, _ := ret[0].(map[string]pbehavior.ResolveResult)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// ResolveAll indicates an expected call of ResolveAll
func (mr *MockEntityTypeResolverMockRecorder) ResolveAll(arg0, arg1, arg2 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "ResolveAll", reflect.TypeOf((*MockEntityTypeResolver)(nil).ResolveAll), arg0, arg1, arg2)
}
