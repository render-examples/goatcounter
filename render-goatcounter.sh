#!/bin/bash
set -e

CMD="$1"
shift

ARGS=("$@")

if [[ "$CMD" == @(serve|create|migrate) ]]; then
  ARGS+=(-db "$DATABASE_URL")
fi

if [[ "$CMD" == "serve" ]]; then
  ARGS+=(-listen "0.0.0.0:80" -tls none -automigrate)
fi

if [[ "$CMD" == "create" ]]; then
  ARGS+=(-domain "$RENDER_EXTERNAL_HOSTNAME")
fi

# If we are running serve, try to initialize the database.
if [[ "$CMD" == "serve" ]]; then
  if ! psql "$DATABASE_URL" --set ON_ERROR_STOP=1 -c "SELECT count(*) FROM sites" >/dev/null 2>&1; then
    echo "R> Initializing Goat Counter database schema..."
    psql "$DATABASE_URL" --set ON_ERROR_STOP=1 -c "\i /etc/schema.pgsql"
    echo "R> Done!"
  else
    echo "R> Goat Counter database schema is already initialized."
  fi

  if [[ -n "$GC_USER_EMAIL" ]] && [[ -n "$GC_PASSWORD" ]]; then
    if [[ $(
      psql -Atx "$DATABASE_URL" --set ON_ERROR_STOP=1 \
        -c "SELECT count(*) FROM sites WHERE cname = '$RENDER_EXTERNAL_HOSTNAME'"
    ) -le 0 ]]; then
      echo "R> Creating initial user account."
      $0 create -email "$GC_USER_EMAIL" -password "$GC_PASSWORD"
      echo "R> Done!"
    else
      echo "R> Main Goat Counter domain exists."
    fi
  else
    echo "R> No GC_USER_EMAIL and/or GC_PASSWORD provided."
  fi

  echo
fi

exec /bin/goatcounter "$CMD" "${ARGS[@]}"
