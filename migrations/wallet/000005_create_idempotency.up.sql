CREATE TABLE idempotency (
  scope VARCHAR(255) NOT NULL,
  key VARCHAR(255) NOT NULL,
  request_hash VARCHAR(64) NOT NULL,
  response_status INT NULL,
  response_body JSONB NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (scope, key)
);