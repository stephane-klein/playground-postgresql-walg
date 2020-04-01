FROM postgres:12.2

RUN mkdir -p /etc/postgresql/ \
    && cp /usr/share/postgresql/postgresql.conf.sample /etc/postgresql/postgresql.conf \
    && sed -ri "s/^#archive_mode = off/archive_mode = on/" /etc/postgresql/postgresql.conf \
    && sed -ri "s/^#archive_timeout = 0/archive_timeout = 60/" /etc/postgresql/postgresql.conf

CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]