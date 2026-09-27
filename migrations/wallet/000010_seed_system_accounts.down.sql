DELETE FROM balances WHERE account_id IN (SELECT id FROM accounts WHERE owner_user_id IS NULL);
DELETE FROM accounts WHERE owner_user_id IS NULL;