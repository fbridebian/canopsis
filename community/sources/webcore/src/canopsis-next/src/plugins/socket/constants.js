export const REQUEST_MESSAGES_TYPES = {
  ping: 0,
  join: 1,
  leave: 2,
  authenticate: 3,
  heartbeat: 4,
};

export const RESPONSE_MESSAGES_TYPES = {
  pong: 0,
  ok: 1,
  error: 2,
  close: 3,
};

export const MAX_RECONNECTS_COUNT = 10;

export const PING_INTERVAL = 10000;

export const RECONNECT_INTERVAL = 5000;
