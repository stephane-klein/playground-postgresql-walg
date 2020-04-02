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

ENV PGHOST=/var/run/postgresql
ENV ARCHIVE_MODE=off
ENV ARCHIVE_TIMEOUT=0

CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]