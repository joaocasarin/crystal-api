#!/bin/sh

set -e

host="db"
shift
cmd="$@"

until PGPASSWORD=password psql -h "$host" -U "postgres" -c '\l'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up - executing command"
exec $cmd
