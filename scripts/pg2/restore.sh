#!/usr/bin/env bash
set -e

cd "$(dirname "$0")/../../"

docker-compose stop postgres2
rm -rf volumes/postgres2/
docker-compose run --rm postgres2 sh -c '/wal-g backup-fetch $PGDATA LATEST; touch $PGDATA/recovery.signal'
docker-compose up -d postgres2