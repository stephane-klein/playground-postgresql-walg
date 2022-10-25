#!/usr/bin/env bash
set -e

cd "$(dirname "$0")/../"

./scripts/build-wal-g-docker-image.sh

docker build ./docker-image/postgres-with-wal-g -t stephaneklein/postgres-with-walg:15-alpine-walg2.0.0