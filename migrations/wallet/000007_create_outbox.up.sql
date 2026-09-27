CREATE TABLE outbox (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  event_id UUID NOT NULL UNIQUE,
  type VARCHAR(128) NOT NULL,
  version INT NOT NULL,
  partition_key VARCHAR(128) NOT NULL,
  transaction_id BIGINT NOT NULL REFERENCES transactions(id),
  payload JSONB NOT NULL,
  occurred_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  published_at TIMESTAMPTZ NULL
);

CREATE INDEX ix_outbox_unpublished ON outbox (id) WHERE published_at IS NULL;