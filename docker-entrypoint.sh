#!/bin/bash
set -e

export GC_DOMAIN="${RENDER_EXTERNAL_HOSTNAME}"

# Create site
{
    echo 'Creating site...'
    goatcounter create \
    -domain "${GC_DOMAIN}" \
    -email "${GC_USER_EMAIL}" \
    -password "${GC_PASSWORD}" \
    -db "${DB_CONNECTION_STRING}"
} || {
    :
}

# Run site
{
    goatcounter serve -listen "0.0.0.0:80" -db "${DB_CONNECTION_STRING}" -tls none -automigrate
} || {
    # Load db schema
    echo 'Loading Goat Counter schema...'
    PGPASSWORD="${DB_PASSWORD}" psql -h postgres.render.com -U "${DB_USER}" "${DB_NAME}" -c '\i db/schema.pgsql'  

    echo 'Serving site...'
    goatcounter serve -listen "0.0.0.0:80" -db "${DB_CONNECTION_STRING}" -tls none -automigrate
}

exec "$@"