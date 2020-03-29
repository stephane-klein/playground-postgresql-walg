#!/usr/bin/env bash
set -e

cd "$(dirname "$0")/../"

docker-compose down --rmi all
rm -rf volumes