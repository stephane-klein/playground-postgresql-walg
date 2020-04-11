FROM stephaneklein/wal-g:v0.2.15-alpine3.11.5 AS wal-g
FROM postgres:12.2-alpine

RUN apk update \
    && apk add gomplate

COPY --from=wal-g /wal-g /

RUN mkdir -p /etc/postgresql/ \
    && cp /usr/local/share/postgresql/postgresql.conf.sample /etc/postgresql/postgresql.conf.tmpl \
    && sed -ri "s/^#archive_mode = off/archive_mode = {{.Env.ARCHIVE_MODE}}/" /etc/postgresql/postgresql.conf.tmpl \
    && sed -ri "s/^#archive_timeout = 0/archive_timeout = {{.Env.ARCHIVE_TIMEOUT}}/" /etc/postgresql/postgresql.conf.tmpl \
    && sed -ri "s/^#archive_command = ''/archive_command = '\/wal-g wal-push %p'/" /etc/postgresql/postgresql.conf.tmpl \
    && sed -ri "s/^#restore_command = ''/restore_command = '\/wal-g wal-fetch %f %p'/" /etc/postgresql/postgresql.conf.tmpl

ADD docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod u+x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

# See environment variables documentation https://github.com/wal-g/wal-g#configuration
#ENV WALE_S3_PREFIX=s3://bucket/path/to/folder
#ENV AWS_ACCESS_KEY_ID=xxxx
#ENV AWS_SECRET_ACCESS_KEY=secret
#ENV AWS_REGION=us-west-2
#ENV AWS_ENDPOINT=http://s3-like-service:9000
ENV AWS_S3_FORCE_PATH_STYLE=true
ENV WALG_COMPRESSION_METHOD brotli

# See environment variables documentation https://github.com/wal-g/wal-g/blob/master/PostgreSQL.md#configuration
ENV PGHOST=/var/run/postgresql
ENV PGUSER=postgres
#ENV PGPASSWORD=secret
ENV ARCHIVE_MODE=off
ENV ARCHIVE_TIMEOUT=0
#ENV WALG_PGP_KEY_PATH=/keys/wal-g.pub

CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]