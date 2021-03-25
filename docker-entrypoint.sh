#!/bin/bash
set -e

export GC_DOMAIN="${RENDER_EXTERNAL_HOSTNAME}"
export DB_HOSTNAME=${DB_HOSTNAME:-'oregon-postgres.render.com'}

migrate_db ()
{
  goatcounter migrate \
    -createdb \
    -db "$DB_CONNECTION_STRING" \
    all
}

create_site ()
{
  goatcounter create \
    -domain "$GC_DOMAIN" \
    -email "$GC_USER_EMAIL" \
    -password "$GC_PASSWORD" \
    -db "$DB_CONNECTION_STRING"
}

{
  migrate_db
} || {
  echo 'Failed to run migrations'
}

# Create site
{
  create_site
} || {
  echo 'Failed to create site'
}

declare OPTS=""

OPTS="$OPTS -listen 0.0.0.0:10000"
OPTS="$OPTS -tls none"
OPTS="$OPTS -db $DB_CONNECTION_STRING"
OPTS="$OPTS -automigrate"


if [ -n "$GC_DEBUG" ]; then
  OPTS="$OPTS -debug all"
fi

# Run site
{
  echo 'Serving site...'
  goatcounter serve $OPTS
} || {
    # Load db schema
    echo 'Loading Goat Counter schema...'
    PGPASSWORD="${DB_PASSWORD}" psql -h "${DB_HOSTNAME}" -U "${DB_USER}" "${DB_NAME}" -c '\i db/schema.pgsql'

    echo 'Serving site...'
    goatcounter serve $OPTS
}

exec "$@"
