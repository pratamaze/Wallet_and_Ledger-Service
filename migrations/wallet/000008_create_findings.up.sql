CREATE TYPE finding_status AS ENUM ('OPEN', 'RESOLVED');

CREATE TABLE findings (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  check_name VARCHAR(64) NOT NULL,
  subject VARCHAR(128) NOT NULL,
  expected TEXT NOT NULL,
  actual TEXT NOT NULL,
  status finding_status NOT NULL DEFAULT 'OPEN',
  detected_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX ux_findings_open ON findings (check_name, subject) WHERE status = 'OPEN';