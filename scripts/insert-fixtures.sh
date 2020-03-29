#!/usr/bin/env bash
set -e

cd "$(dirname "$0")/../"

docker exec $(docker-compose ps -q postgres) sh -c "rm -rf /sqls/"
docker cp sqls/ $(docker-compose ps -q postgres):/sqls/
docker-compose exec postgres sh -c "cd /sqls/ && psql --quiet -U \$POSTGRES_USER \$POSTGRES_DB -f /sqls/fixtures.sql"