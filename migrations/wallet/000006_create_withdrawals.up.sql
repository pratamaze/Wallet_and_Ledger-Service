CREATE TYPE withdrawal_status AS ENUM ('REQUESTED', 'SENDING', 'PENDING', 'UNKNOWN', 'SUCCEEDED', 'FAILED');

CREATE TABLE withdrawals (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  account_id BIGINT NOT NULL REFERENCES accounts(id),
  amount BIGINT NOT NULL CHECK (amount > 0),
  dest_bank_code VARCHAR(32) NULL,
  dest_account_number VARCHAR(64) NULL,
  dest_account_name VARCHAR(128) NULL,
  status withdrawal_status NOT NULL DEFAULT 'REQUESTED',
  attempts INT NOT NULL DEFAULT 0,
  next_attempt_at TIMESTAMPTZ NULL,
  lease_until TIMESTAMPTZ NULL,
  expires_at TIMESTAMPTZ NULL,
  hold_tx_id BIGINT NULL REFERENCES transactions(id),
  final_tx_id BIGINT NULL REFERENCES transactions(id),
  bank_ref VARCHAR(255) NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);