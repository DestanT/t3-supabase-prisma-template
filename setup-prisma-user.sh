#!/usr/bin/env bash

set -e

source .env

if [ -z "$PRISMA_USER_PASSWORD" ]; then
    echo "Error: PRISMA_USER_PASSWORD environment variable is not set"
    echo "Please set PRISMA_USER_PASSWORD in your .env file"
    exit 1
fi

echo "Creating Prisma user with superuser privileges..."

# Connect as postgres superuser to create the prisma user
psql "$DIRECT_URL" << EOF
-- Create custom user if it doesn't exist
DO \$\$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'prisma') THEN
        create user "prisma" with password '$PRISMA_USER_PASSWORD' bypassrls createdb;
        
        -- extend prisma's privileges to postgres (necessary to view changes in Dashboard)
        grant "prisma" to "postgres";
        
        -- Grant it necessary permissions over the relevant schemas (public)
        grant usage on schema public to prisma;
        grant create on schema public to prisma;
        grant all on all tables in schema public to prisma;
        grant all on all routines in schema public to prisma;
        grant all on all sequences in schema public to prisma;
        alter default privileges for role postgres in schema public grant all on tables to prisma;
        alter default privileges for role postgres in schema public grant all on routines to prisma;
        alter default privileges for role postgres in schema public grant all on sequences to prisma;
        
        RAISE NOTICE 'Prisma user created successfully';
    ELSE
        RAISE NOTICE 'Prisma user already exists';
    END IF;
END
\$\$;
EOF

echo "✓ Prisma user setup complete!"