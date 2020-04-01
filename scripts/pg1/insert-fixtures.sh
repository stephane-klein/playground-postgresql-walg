#!/usr/bin/env bash
set -e

cd "$(dirname "$0")/../../"

docker exec $(docker-compose ps -q postgres1) sh -c "rm -rf /sqls/"
docker cp sqls/ $(docker-compose ps -q postgres1):/sqls/
docker-compose exec postgres1 sh -c "cd /sqls/ && psql --quiet -U \$POSTGRES_USER \$POSTGRES_DB -f /sqls/fixtures.sql"