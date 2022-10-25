#!/usr/bin/env bash
set -e

cd "$(dirname "$0")/../"

docker build ./docker-image/wal-g/ -t stephaneklein/wal-g:v2.0.1-alpine3.16