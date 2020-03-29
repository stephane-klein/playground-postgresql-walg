#!/usr/bin/env bash
set -e

cd "$(dirname "$0")/../"

docker-compose exec postgres sh -c '/wal-g backup-push -f $PGDATA'