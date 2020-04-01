#!/usr/bin/env bash
set -e

cd "$(dirname "$0")/../../"

echo "select * from pg_stat_archiver;" | docker-compose exec -T postgres1 sh -c "psql -x -U \$POSTGRES_USER \$POSTGRES_DB -a -q -f -"
