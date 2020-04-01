FROM stephaneklein/wal-g:v0.2.15-alpine3.11.5 AS wal-g
FROM postgres:12.2-alpine

COPY --from=wal-g /wal-g /

RUN mkdir -p /etc/postgresql/ \
    && cp /usr/local/share/postgresql/postgresql.conf.sample /etc/postgresql/postgresql.conf \
    && sed -ri "s/^#archive_mode = off/archive_mode = on/" /etc/postgresql/postgresql.conf \
    && sed -ri "s/^#archive_timeout = 0/archive_timeout = 60/" /etc/postgresql/postgresql.conf \
    && sed -ri "s/^#archive_command = ''/archive_command = '\/wal-g wal-push %p'/" /etc/postgresql/postgresql.conf \
    && sed -ri "s/^#restore_command = ''/restore_command = '\/wal-g wal-fetch %f %p'/" /etc/postgresql/postgresql.conf

ENV PGHOST=/var/run/postgresql

CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]