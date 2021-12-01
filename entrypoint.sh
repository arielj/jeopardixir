#!/bin/bash
while ! pg_isready -q -h $PGHOST -p $PGPORT -U $PGUSER
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

mix deps.get

# Create, migrate, and seed database if it doesn't exist.
if [[ -z `psql -Atqc "\\list $PGDATABASE"` ]]; then
  echo "Database $PGDATABASE does not exist. Creating..."
  # createdb -E UTF8 $PGDATABASE -l en_US.UTF-8 -T template0
  mix setup
  echo "Database $PGDATABASE created."
fi

mix ecto.migrate
mix phx.server
