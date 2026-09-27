CREATE TYPE account_type AS ENUM ('USER_WALLET', 'BANK_CLEARING', 'SUSPENSE', 'WITHDRAWAL_PENDING');
CREATE TYPE account_status AS ENUM ('ACTIVE', 'FROZEN');

CREATE TABLE accounts (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  type account_type NOT NULL,
  owner_user_id BIGINT NULL,
  currency VARCHAR(3) NOT NULL DEFAULT 'IDR',
  status account_status NOT NULL DEFAULT 'ACTIVE',
  virtual_account VARCHAR(64) NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX ux_accounts_owner_currency ON accounts (owner_user_id, currency) WHERE owner_user_id IS NOT NULL;
CREATE UNIQUE INDEX ux_accounts_va ON accounts (virtual_account) WHERE virtual_account IS NOT NULL;