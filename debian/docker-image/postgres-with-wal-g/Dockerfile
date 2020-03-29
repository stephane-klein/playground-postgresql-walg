FROM stephaneklein/wal-g:v0.2.15-buster AS wal-g
FROM postgres:12.2

COPY --from=wal-g /wal-g /

RUN mkdir -p /etc/postgresql/ \
    && cp /usr/share/postgresql/postgresql.conf.sample /etc/postgresql/postgresql.conf \
    && sed -ri "s/^#archive_mode = off/archive_mode = on/" /etc/postgresql/postgresql.conf \
    && sed -ri "s/^#archive_command = ''/archive_command = '\/wal-g wal-push %p'/" /etc/postgresql/postgresql.conf \
    && sed -ri "s/^#restore_command = ''/restore_command = '\/wal-g wal-fetch %f %p'/" /etc/postgresql/postgresql.conf

ENV PGHOST=/var/run/postgresql

CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]