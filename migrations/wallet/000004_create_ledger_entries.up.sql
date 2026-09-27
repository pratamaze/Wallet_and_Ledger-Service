CREATE TYPE entry_direction AS ENUM ('DEBIT', 'CREDIT');

CREATE TABLE ledger_entries (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  transaction_id BIGINT NOT NULL REFERENCES transactions(id),
  account_id BIGINT NOT NULL REFERENCES accounts(id),
  direction entry_direction NOT NULL,
  amount BIGINT NOT NULL CHECK (amount > 0),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);