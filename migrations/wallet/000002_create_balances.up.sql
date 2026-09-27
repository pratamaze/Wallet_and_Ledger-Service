CREATE TABLE balances (
  account_id BIGINT PRIMARY KEY REFERENCES accounts(id),
  balance BIGINT NOT NULL DEFAULT 0,
  allow_negative BOOLEAN NOT NULL DEFAULT false,
  CONSTRAINT chk_balance_nonneg CHECK (allow_negative OR balance >= 0)
);

CREATE OR REPLACE FUNCTION check_allow_negative_account_type()
RETURNS TRIGGER AS $$
DECLARE
    v_account_type account_type;
BEGIN
    IF NEW.allow_negative = true THEN
        SELECT type INTO v_account_type FROM accounts WHERE id = NEW.account_id;
        IF v_account_type IS DISTINCT FROM 'BANK_CLEARING' THEN
            RAISE EXCEPTION 'allow_negative = true hanya diperbolehkan untuk account_type BANK_CLEARING';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_allow_negative
BEFORE INSERT OR UPDATE ON balances
FOR EACH ROW EXECUTE FUNCTION check_allow_negative_account_type();