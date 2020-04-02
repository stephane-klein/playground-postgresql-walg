#!/bin/bash
set -e

gomplate -f /etc/postgresql/postgresql.conf.tmpl -o /etc/postgresql/postgresql.conf

/usr/local/bin/docker-entrypoint.sh "$@"