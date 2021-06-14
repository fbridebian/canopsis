// Code generated by MockGen. DO NOT EDIT.
// Source: git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/canopsis/engine (interfaces: Engine,Consumer,MessageProcessor,PeriodicalWorker,RPCClient,RPCMessageProcessor)

// Package mock_engine is a generated GoMock package.
package mock_engine

import (
	context "context"
	engine "git.canopsis.net/canopsis/canopsis-community/community/go-engines-community/lib/canopsis/engine"
	gomock "github.com/golang/mock/gomock"
	amqp "github.com/streadway/amqp"
	reflect "reflect"
	time "time"
)

// MockEngine is a mock of Engine interface
type MockEngine struct {
	ctrl     *gomock.Controller
	recorder *MockEngineMockRecorder
}

// MockEngineMockRecorder is the mock recorder for MockEngine
type MockEngineMockRecorder struct {
	mock *MockEngine
}

// NewMockEngine creates a new mock instance
func NewMockEngine(ctrl *gomock.Controller) *MockEngine {
	mock := &MockEngine{ctrl: ctrl}
	mock.recorder = &MockEngineMockRecorder{mock}
	return mock
}

// EXPECT returns an object that allows the caller to indicate expected use
func (m *MockEngine) EXPECT() *MockEngineMockRecorder {
	return m.recorder
}

// AddConsumer mocks base method
func (m *MockEngine) AddConsumer(arg0 engine.Consumer) {
	m.ctrl.T.Helper()
	m.ctrl.Call(m, "AddConsumer", arg0)
}

// AddConsumer indicates an expected call of AddConsumer
func (mr *MockEngineMockRecorder) AddConsumer(arg0 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "AddConsumer", reflect.TypeOf((*MockEngine)(nil).AddConsumer), arg0)
}

// AddPeriodicalWorker mocks base method
func (m *MockEngine) AddPeriodicalWorker(arg0 engine.PeriodicalWorker) {
	m.ctrl.T.Helper()
	m.ctrl.Call(m, "AddPeriodicalWorker", arg0)
}

// AddPeriodicalWorker indicates an expected call of AddPeriodicalWorker
func (mr *MockEngineMockRecorder) AddPeriodicalWorker(arg0 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "AddPeriodicalWorker", reflect.TypeOf((*MockEngine)(nil).AddPeriodicalWorker), arg0)
}

// Run mocks base method
func (m *MockEngine) Run(arg0 context.Context) error {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "Run", arg0)
	ret0, _ := ret[0].(error)
	return ret0
}

// Run indicates an expected call of Run
func (mr *MockEngineMockRecorder) Run(arg0 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "Run", reflect.TypeOf((*MockEngine)(nil).Run), arg0)
}

// MockConsumer is a mock of Consumer interface
type MockConsumer struct {
	ctrl     *gomock.Controller
	recorder *MockConsumerMockRecorder
}

// MockConsumerMockRecorder is the mock recorder for MockConsumer
type MockConsumerMockRecorder struct {
	mock *MockConsumer
}

// NewMockConsumer creates a new mock instance
func NewMockConsumer(ctrl *gomock.Controller) *MockConsumer {
	mock := &MockConsumer{ctrl: ctrl}
	mock.recorder = &MockConsumerMockRecorder{mock}
	return mock
}

// EXPECT returns an object that allows the caller to indicate expected use
func (m *MockConsumer) EXPECT() *MockConsumerMockRecorder {
	return m.recorder
}

// Consume mocks base method
func (m *MockConsumer) Consume(arg0 context.Context) error {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "Consume", arg0)
	ret0, _ := ret[0].(error)
	return ret0
}

// Consume indicates an expected call of Consume
func (mr *MockConsumerMockRecorder) Consume(arg0 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "Consume", reflect.TypeOf((*MockConsumer)(nil).Consume), arg0)
}

// MockMessageProcessor is a mock of MessageProcessor interface
type MockMessageProcessor struct {
	ctrl     *gomock.Controller
	recorder *MockMessageProcessorMockRecorder
}

// MockMessageProcessorMockRecorder is the mock recorder for MockMessageProcessor
type MockMessageProcessorMockRecorder struct {
	mock *MockMessageProcessor
}

// NewMockMessageProcessor creates a new mock instance
func NewMockMessageProcessor(ctrl *gomock.Controller) *MockMessageProcessor {
	mock := &MockMessageProcessor{ctrl: ctrl}
	mock.recorder = &MockMessageProcessorMockRecorder{mock}
	return mock
}

// EXPECT returns an object that allows the caller to indicate expected use
func (m *MockMessageProcessor) EXPECT() *MockMessageProcessorMockRecorder {
	return m.recorder
}

// Process mocks base method
func (m *MockMessageProcessor) Process(arg0 context.Context, arg1 amqp.Delivery) ([]byte, error) {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "Process", arg0, arg1)
	ret0, _ := ret[0].([]byte)
	ret1, _ := ret[1].(error)
	return ret0, ret1
}

// Process indicates an expected call of Process
func (mr *MockMessageProcessorMockRecorder) Process(arg0, arg1 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "Process", reflect.TypeOf((*MockMessageProcessor)(nil).Process), arg0, arg1)
}

// MockPeriodicalWorker is a mock of PeriodicalWorker interface
type MockPeriodicalWorker struct {
	ctrl     *gomock.Controller
	recorder *MockPeriodicalWorkerMockRecorder
}

// MockPeriodicalWorkerMockRecorder is the mock recorder for MockPeriodicalWorker
type MockPeriodicalWorkerMockRecorder struct {
	mock *MockPeriodicalWorker
}

// NewMockPeriodicalWorker creates a new mock instance
func NewMockPeriodicalWorker(ctrl *gomock.Controller) *MockPeriodicalWorker {
	mock := &MockPeriodicalWorker{ctrl: ctrl}
	mock.recorder = &MockPeriodicalWorkerMockRecorder{mock}
	return mock
}

// EXPECT returns an object that allows the caller to indicate expected use
func (m *MockPeriodicalWorker) EXPECT() *MockPeriodicalWorkerMockRecorder {
	return m.recorder
}

// GetInterval mocks base method
func (m *MockPeriodicalWorker) GetInterval() time.Duration {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "GetInterval")
	ret0, _ := ret[0].(time.Duration)
	return ret0
}

// GetInterval indicates an expected call of GetInterval
func (mr *MockPeriodicalWorkerMockRecorder) GetInterval() *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "GetInterval", reflect.TypeOf((*MockPeriodicalWorker)(nil).GetInterval))
}

// Work mocks base method
func (m *MockPeriodicalWorker) Work(arg0 context.Context) error {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "Work", arg0)
	ret0, _ := ret[0].(error)
	return ret0
}

// Work indicates an expected call of Work
func (mr *MockPeriodicalWorkerMockRecorder) Work(arg0 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "Work", reflect.TypeOf((*MockPeriodicalWorker)(nil).Work), arg0)
}

// MockRPCClient is a mock of RPCClient interface
type MockRPCClient struct {
	ctrl     *gomock.Controller
	recorder *MockRPCClientMockRecorder
}

// MockRPCClientMockRecorder is the mock recorder for MockRPCClient
type MockRPCClientMockRecorder struct {
	mock *MockRPCClient
}

// NewMockRPCClient creates a new mock instance
func NewMockRPCClient(ctrl *gomock.Controller) *MockRPCClient {
	mock := &MockRPCClient{ctrl: ctrl}
	mock.recorder = &MockRPCClientMockRecorder{mock}
	return mock
}

// EXPECT returns an object that allows the caller to indicate expected use
func (m *MockRPCClient) EXPECT() *MockRPCClientMockRecorder {
	return m.recorder
}

// Call mocks base method
func (m *MockRPCClient) Call(arg0 engine.RPCMessage) error {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "Call", arg0)
	ret0, _ := ret[0].(error)
	return ret0
}

// Call indicates an expected call of Call
func (mr *MockRPCClientMockRecorder) Call(arg0 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "Call", reflect.TypeOf((*MockRPCClient)(nil).Call), arg0)
}

// Consume mocks base method
func (m *MockRPCClient) Consume(arg0 context.Context) error {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "Consume", arg0)
	ret0, _ := ret[0].(error)
	return ret0
}

// Consume indicates an expected call of Consume
func (mr *MockRPCClientMockRecorder) Consume(arg0 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "Consume", reflect.TypeOf((*MockRPCClient)(nil).Consume), arg0)
}

// MockRPCMessageProcessor is a mock of RPCMessageProcessor interface
type MockRPCMessageProcessor struct {
	ctrl     *gomock.Controller
	recorder *MockRPCMessageProcessorMockRecorder
}

// MockRPCMessageProcessorMockRecorder is the mock recorder for MockRPCMessageProcessor
type MockRPCMessageProcessorMockRecorder struct {
	mock *MockRPCMessageProcessor
}

// NewMockRPCMessageProcessor creates a new mock instance
func NewMockRPCMessageProcessor(ctrl *gomock.Controller) *MockRPCMessageProcessor {
	mock := &MockRPCMessageProcessor{ctrl: ctrl}
	mock.recorder = &MockRPCMessageProcessorMockRecorder{mock}
	return mock
}

// EXPECT returns an object that allows the caller to indicate expected use
func (m *MockRPCMessageProcessor) EXPECT() *MockRPCMessageProcessorMockRecorder {
	return m.recorder
}

// Process mocks base method
func (m *MockRPCMessageProcessor) Process(arg0 engine.RPCMessage) error {
	m.ctrl.T.Helper()
	ret := m.ctrl.Call(m, "Process", arg0)
	ret0, _ := ret[0].(error)
	return ret0
}

// Process indicates an expected call of Process
func (mr *MockRPCMessageProcessorMockRecorder) Process(arg0 interface{}) *gomock.Call {
	mr.mock.ctrl.T.Helper()
	return mr.mock.ctrl.RecordCallWithMethodType(mr.mock, "Process", reflect.TypeOf((*MockRPCMessageProcessor)(nil).Process), arg0)
}
