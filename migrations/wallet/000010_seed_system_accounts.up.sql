INSERT INTO accounts (type, owner_user_id, currency, status) VALUES
  ('BANK_CLEARING', NULL, 'IDR', 'ACTIVE'),
  ('SUSPENSE', NULL, 'IDR', 'ACTIVE'),
  ('WITHDRAWAL_PENDING', NULL, 'IDR', 'ACTIVE');

INSERT INTO balances (account_id, balance, allow_negative)
SELECT id, 0, (type = 'BANK_CLEARING') FROM accounts WHERE owner_user_id IS NULL;