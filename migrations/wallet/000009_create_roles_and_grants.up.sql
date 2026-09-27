-- Role app: Hak akses CRUD terbatas
GRANT SELECT, INSERT ON accounts, balances, transactions, idempotency, withdrawals, findings TO app;
GRANT UPDATE (status) ON accounts TO app;
GRANT UPDATE (balance) ON balances TO app;
GRANT UPDATE (status, refunded_amount) ON transactions TO app;
GRANT UPDATE (status, attempts, next_attempt_at, lease_until, hold_tx_id, final_tx_id, bank_ref) ON withdrawals TO app;
GRANT INSERT ON ledger_entries TO app;
GRANT INSERT ON outbox TO app;

-- Role relay: Hak akses pengiriman Outbox
GRANT SELECT, DELETE ON outbox TO relay;
GRANT UPDATE (published_at) ON outbox TO relay;

-- Role reconciler: Hak akses audit pembacaan & penulisan temuan
GRANT SELECT ON ALL TABLES IN SCHEMA public TO reconciler;
GRANT INSERT ON findings TO reconciler;