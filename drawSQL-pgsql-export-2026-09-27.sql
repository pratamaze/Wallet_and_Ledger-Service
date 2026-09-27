CREATE TABLE "accounts"(
    "id" bigserial NOT NULL,
    "type" INTEGER NOT NULL,
    "owner_user_id" BIGINT NULL,
    "currency" VARCHAR(3) NOT NULL DEFAULT 'IDR',
    "status" INTEGER NOT NULL DEFAULT 'ACTIVE',
    "virtual_account" VARCHAR(64) NULL,
    "created_at" TIMESTAMP(0) WITH
        TIME zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE
    "accounts" ADD CONSTRAINT "accounts_owner_user_id_currency_owner_user_id_unique" UNIQUE(
        "owner_user_id",
        "currency",
        "owner_user_id"
    );
ALTER TABLE
    "accounts" ADD CONSTRAINT "accounts_virtual_account_virtual_account_unique" UNIQUE(
        "virtual_account",
        "virtual_account"
    );
ALTER TABLE
    "accounts" ADD PRIMARY KEY("id");
CREATE TABLE "balances"(
    "account_id" BIGINT NOT NULL,
    "balance" BIGINT NOT NULL,
    "allow_negative" BOOLEAN NOT NULL
);
ALTER TABLE
    "balances" ADD PRIMARY KEY("account_id");
CREATE TABLE "transactions"(
    "id" bigserial NOT NULL,
    "type" INTEGER NOT NULL,
    "status" INTEGER NOT NULL DEFAULT 'COMPLETED',
    "amount" BIGINT NOT NULL,
    "source" VARCHAR(64) NOT NULL,
    "external_ref" VARCHAR(255) NULL,
    "reference" VARCHAR(255) NULL,
    "original_tx_id" BIGINT NULL,
    "refunded_amount" BIGINT NOT NULL,
    "created_by" VARCHAR(64) NULL,
    "created_at" TIMESTAMP(0) WITH
        TIME zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE
    "transactions" ADD CONSTRAINT "transactions_source_external_ref_external_ref_unique" UNIQUE(
        "source",
        "external_ref",
        "external_ref"
    );
ALTER TABLE
    "transactions" ADD PRIMARY KEY("id");
CREATE TABLE "ledger_entries"(
    "id" bigserial NOT NULL,
    "transaction_id" BIGINT NOT NULL,
    "account_id" BIGINT NOT NULL,
    "direction" INTEGER NOT NULL,
    "amount" BIGINT NOT NULL,
    "created_at" TIMESTAMP(0) WITH
        TIME zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE
    "ledger_entries" ADD PRIMARY KEY("id");
CREATE TABLE "idempotency"(
    "scope" VARCHAR(255) NOT NULL,
    "key" VARCHAR(255) NOT NULL,
    "request_hash" VARCHAR(64) NOT NULL,
    "response_status" INTEGER NULL,
    "response_body" jsonb NULL,
    "created_at" TIMESTAMP(0) WITH
        TIME zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE
    "idempotency" ADD PRIMARY KEY("scope");
ALTER TABLE
    "idempotency" ADD PRIMARY KEY("key");
CREATE TABLE "withdrawals"(
    "id" bigserial NOT NULL,
    "account_id" BIGINT NOT NULL,
    "amount" BIGINT NOT NULL,
    "dest_bank_code" VARCHAR(32) NULL,
    "dest_account_number" VARCHAR(64) NULL,
    "dest_account_name" VARCHAR(128) NULL,
    "status" INTEGER NOT NULL DEFAULT 'REQUESTED',
    "attempts" INTEGER NOT NULL,
    "next_attempt_at" TIMESTAMP(0) WITH
        TIME zone NULL,
        "lease_until" TIMESTAMP(0)
    WITH
        TIME zone NULL,
        "expires_at" TIMESTAMP(0)
    WITH
        TIME zone NULL,
        "hold_tx_id" BIGINT NULL,
        "final_tx_id" BIGINT NULL,
        "bank_ref" VARCHAR(255) NULL,
        "created_at" TIMESTAMP(0)
    WITH
        TIME zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE
    "withdrawals" ADD PRIMARY KEY("id");
CREATE TABLE "outbox"(
    "id" bigserial NOT NULL,
    "event_id" UUID NOT NULL,
    "type" VARCHAR(128) NOT NULL,
    "version" INTEGER NOT NULL,
    "partition_key" VARCHAR(128) NOT NULL,
    "transaction_id" BIGINT NOT NULL,
    "payload" jsonb NOT NULL,
    "occurred_at" TIMESTAMP(0) WITH
        TIME zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
        "published_at" TIMESTAMP(0)
    WITH
        TIME zone NULL
);
ALTER TABLE
    "outbox" ADD PRIMARY KEY("id");
ALTER TABLE
    "outbox" ADD CONSTRAINT "outbox_event_id_unique" UNIQUE("event_id");
CREATE TABLE "findings"(
    "id" bigserial NOT NULL,
    "check_name" VARCHAR(64) NOT NULL,
    "subject" VARCHAR(128) NOT NULL,
    "expected" TEXT NOT NULL,
    "actual" TEXT NOT NULL,
    "status" INTEGER NOT NULL DEFAULT 'OPEN',
    "detected_at" TIMESTAMP(0) WITH
        TIME zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE
    "findings" ADD CONSTRAINT "findings_check_name_subject_status_unique" UNIQUE("check_name", "subject", "status");
ALTER TABLE
    "findings" ADD PRIMARY KEY("id");
CREATE TABLE "orders"(
    "id" bigserial NOT NULL,
    "reference" VARCHAR(255) NOT NULL,
    "amount" BIGINT NOT NULL,
    "payer_account_id" BIGINT NULL,
    "payee_account_id" BIGINT NULL,
    "status" INTEGER NOT NULL DEFAULT 'PENDING',
    "created_at" TIMESTAMP(0) WITH
        TIME zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
        "updated_at" TIMESTAMP(0)
    WITH
        TIME zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE
    "orders" ADD PRIMARY KEY("id");
ALTER TABLE
    "orders" ADD CONSTRAINT "orders_reference_unique" UNIQUE("reference");
CREATE TABLE "processed_events"(
    "event_id" UUID NOT NULL,
    "processed_at" TIMESTAMP(0) WITH
        TIME zone NOT NULL DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE
    "processed_events" ADD PRIMARY KEY("event_id");
ALTER TABLE
    "withdrawals" ADD CONSTRAINT "withdrawals_account_id_foreign" FOREIGN KEY("account_id") REFERENCES "accounts"("id");
ALTER TABLE
    "balances" ADD CONSTRAINT "balances_account_id_foreign" FOREIGN KEY("account_id") REFERENCES "accounts"("id");
ALTER TABLE
    "withdrawals" ADD CONSTRAINT "withdrawals_final_tx_id_foreign" FOREIGN KEY("final_tx_id") REFERENCES "transactions"("id");
ALTER TABLE
    "withdrawals" ADD CONSTRAINT "withdrawals_hold_tx_id_foreign" FOREIGN KEY("hold_tx_id") REFERENCES "transactions"("id");
ALTER TABLE
    "outbox" ADD CONSTRAINT "outbox_transaction_id_foreign" FOREIGN KEY("transaction_id") REFERENCES "transactions"("id");
ALTER TABLE
    "ledger_entries" ADD CONSTRAINT "ledger_entries_account_id_foreign" FOREIGN KEY("account_id") REFERENCES "accounts"("id");
ALTER TABLE
    "ledger_entries" ADD CONSTRAINT "ledger_entries_transaction_id_foreign" FOREIGN KEY("transaction_id") REFERENCES "transactions"("id");
ALTER TABLE
    "transactions" ADD CONSTRAINT "transactions_original_tx_id_foreign" FOREIGN KEY("original_tx_id") REFERENCES "transactions"("id");