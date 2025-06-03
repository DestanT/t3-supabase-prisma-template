#!/usr/bin/env bash

set -e

source .env

echo "Setting up shadow database..."

# Drop and recreate shadow database
psql "$DIRECT_URL" -c "DROP DATABASE IF EXISTS shadow_db;"
psql "$DIRECT_URL" -c "CREATE DATABASE shadow_db;"

echo "Dumping auth schema..."
pg_dump -v -n auth -s "$DIRECT_URL" > supabase_auth.sql

echo "Applying auth schema to shadow database..."
psql "$SHADOW_DATABASE_URL" < supabase_auth.sql
echo "✓ Shadow database setup complete!"
