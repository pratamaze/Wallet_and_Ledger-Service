CREATE TYPE tx_type AS ENUM ('TRANSFER', 'TOPUP', 'TOPUP_SUSPENSE', 'WITHDRAWAL_HOLD', 'WITHDRAWAL_SETTLE', 'WITHDRAWAL_RELEASE', 'SUSPENSE_RESOLUTION', 'REFUND');
CREATE TYPE tx_status AS ENUM ('COMPLETED', 'PARTIALLY_REFUNDED', 'REVERSED');

CREATE TABLE transactions (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  type tx_type NOT NULL,
  status tx_status NOT NULL DEFAULT 'COMPLETED',
  amount BIGINT NOT NULL CHECK (amount > 0),
  source VARCHAR(64) NOT NULL,
  external_ref VARCHAR(255) NULL,
  reference VARCHAR(255) NULL,
  original_tx_id BIGINT NULL REFERENCES transactions(id),
  refunded_amount BIGINT NOT NULL DEFAULT 0 CHECK (refunded_amount BETWEEN 0 AND amount),
  created_by VARCHAR(64) NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT chk_refund_has_original CHECK ((type = 'REFUND') = (original_tx_id IS NOT NULL))
);

CREATE UNIQUE INDEX ux_tx_source_extref ON transactions (source, external_ref) WHERE external_ref IS NOT NULL;