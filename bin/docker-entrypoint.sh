#!/bin/bash
set -e

# Enable jemalloc for reduced memory usage and latency.
if [ -z "${LD_PRELOAD+x}" ]; then
  LD_PRELOAD=$(find /usr/lib -name libjemalloc.so.2 -print -quit)
  export LD_PRELOAD
fi

cmd="$1"
subcmd="$2"

# Only prep the DB when running the Rails server
if [[ "$cmd" == "./bin/rails" && "$subcmd" == "server" ]]; then
  # Wait for Postgres
  until pg_isready -h "${DB_HOST:-db}" -U "${DB_USERNAME:-postgres}"; do
    echo "Waiting for database..."
    sleep 1
  done

  # Create DB if missing
  if ! "$cmd" db:version > /dev/null 2>&1; then
    echo "Database not found, creating..."
    "$cmd" db:create
  fi

  # Migrate
  echo "Running migrations..."
  "$cmd" db:migrate
fi

# Hand off to the original command (Rails server, Sidekiq, etc.)
exec "$@"