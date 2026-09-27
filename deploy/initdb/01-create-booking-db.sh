#!/bin/bash
set -e

# Eksekusi psql menggunakan user postgres ke database utama ($POSTGRES_DB / wallet)
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    -- database booking eksplisit
    CREATE DATABASE booking;

    -- Role untuk Database Wallet (wallet)
    CREATE ROLE migrator WITH LOGIN PASSWORD 'migrator_secret';
    CREATE ROLE app WITH LOGIN PASSWORD 'app_secret';
    CREATE ROLE relay WITH LOGIN PASSWORD 'relay_secret';
    CREATE ROLE reconciler WITH LOGIN PASSWORD 'reconciler_secret';

    GRANT CONNECT ON DATABASE wallet TO migrator, app, relay, reconciler;

    -- Role untuk Database Booking
    CREATE ROLE booking_app WITH LOGIN PASSWORD 'booking_secret';
    GRANT ALL PRIVILEGES ON DATABASE booking TO booking_app;
EOSQL
