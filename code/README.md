I use this folder to work on walg source code.

```
$ git clone --branch v0.2.15 --single-branch https://github.com/wal-g/wal-g.git src/wal-g/
$ (cd src/ ; git switch -c v0.2.15)
```

```
$ docker-compose build
$ docker-compose up -d
```

Wait postgresql is started.

```
$ ./scripts/load-seed.sh
$ ./scripts/insert-fixtures.sh
```

Check postgresql configuration:

```
$ ./scripts/enter-in-pg.sh
postgres=# show archive_mode;
 archive_mode
--------------
 on
(1 row)

postgres=# show wal_level;;
 wal_level
-----------
 replica
(1 row)
```


```
$ docker-compose exec walg bash
# cd /go/wal-g/
# make install
# make deps
# make pg_build
# make link_brotli
# ./main/pg/wal-g --version
wal-g version v0.2.15	f6abd0c	2020.03.29_15:46:42	PostgreSQL
# ./main/pg/wal-g backup-push -f /var/lib/postgresql/data/
```