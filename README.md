# POC wal-g - Archival and Restoration for Postgres

Project status: this is a draft in work in progress.

```
$ ./scripts/build-wal-g-docker-image.sh
$ docker-compose build
$ docker-compose up -d postgres1 s3
```

Wait `postgres1` starting…

```
$ ./scripts/pg1/load-seed.sh
$ ./scripts/pg1/insert-fixtures.sh
```

```
$ ./scripts/pg1/query.sh
 count
-------
    10
(1 row)
```

Execute first fullbackup on `postgres1`:

```
$ ./scripts/pg1/make-basebackup.sh
```


```
$ ./scripts/pg1/show-pg-stats-archiver.sh
-[ RECORD 1 ]------+-----------------------------------------
archived_count     | 4
last_archived_wal  | 000000010000000000000003.00000028.backup
last_archived_time | 2020-04-01 22:12:52.273572+00
failed_count       | 0
last_failed_wal    |
last_failed_time   |
stats_reset        | 2020-04-01 22:12:19.392116+00
```

```
$ ./scripts/pg1/insert-fixtures.sh
$ ./scripts/pg1/query.sh
 count
-------
    20
(1 row)
```

wait 60s, next execute:

```
$ ./scripts/pg1/show-pg-stats-archiver.sh
select * from pg_stat_archiver;
-[ RECORD 1 ]------+------------------------------
-[ RECORD 1 ]------+------------------------------
archived_count     | 5
last_archived_wal  | 000000010000000000000004
last_archived_time | 2020-04-01 22:15:53.046315+00
failed_count       | 0
last_failed_wal    |
last_failed_time   |
stats_reset        | 2020-04-01 22:12:19.392116+00
```

```
$ ./scripts/pg2/restore.sh
```

```
$ docker-compose logs -f postgres2
Attaching to poc-wal-g_postgres2_1
postgres2_1  |
postgres2_1  | PostgreSQL Database directory appears to contain a database; Skipping initialization
postgres2_1  |
postgres2_1  | 2020-04-01 22:16:22.523 GMT [1] LOG:  starting PostgreSQL 12.2 on x86_64-pc-linux-musl, compiled by gcc (Alpine 9.2.0) 9.2.0, 64-bit
postgres2_1  | 2020-04-01 22:16:22.523 GMT [1] LOG:  listening on IPv4 address "0.0.0.0", port 5432
postgres2_1  | 2020-04-01 22:16:22.523 GMT [1] LOG:  listening on IPv6 address "::", port 5432
postgres2_1  | 2020-04-01 22:16:22.526 GMT [1] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
postgres2_1  | 2020-04-01 22:16:22.589 GMT [21] LOG:  database system was interrupted; last known up at 2020-04-01 22:12:49 GMT
postgres2_1  | 2020-04-01 22:16:22.591 GMT [21] LOG:  creating missing WAL directory "pg_wal/archive_status"
postgres2_1  | ERROR: 2020/04/01 22:16:25.432649 Archive '00000002.history' does not exist.
postgres2_1  | 2020-04-01 22:16:25.434 GMT [21] LOG:  starting archive recovery
postgres2_1  | 2020-04-01 22:16:25.610 GMT [21] LOG:  restored log file "000000010000000000000003" from archive
postgres2_1  | 2020-04-01 22:16:25.698 GMT [21] LOG:  redo starts at 0/3000028
postgres2_1  | 2020-04-01 22:16:25.700 GMT [21] LOG:  consistent recovery state reached at 0/3000100
postgres2_1  | 2020-04-01 22:16:25.700 GMT [1] LOG:  database system is ready to accept read only connections
postgres2_1  | 2020-04-01 22:16:25.916 GMT [21] LOG:  restored log file "000000010000000000000004" from archive
postgres2_1  | ERROR: 2020/04/01 22:16:25.971510 Archive '000000010000000000000005' does not exist.
postgres2_1  | 2020-04-01 22:16:25.974 GMT [21] LOG:  redo done at 0/4001400
postgres2_1  | 2020-04-01 22:16:25.974 GMT [21] LOG:  last completed transaction was at log time 2020-04-01 22:15:16.261152+00
postgres2_1  | 2020-04-01 22:16:26.197 GMT [21] LOG:  restored log file "000000010000000000000004" from archive
postgres2_1  | ERROR: 2020/04/01 22:16:26.239134 Archive '00000002.history' does not exist.
postgres2_1  | 2020-04-01 22:16:26.241 GMT [21] LOG:  selected new timeline ID: 2
postgres2_1  | 2020-04-01 22:16:26.765 GMT [21] LOG:  archive recovery complete
postgres2_1  | ERROR: 2020/04/01 22:16:26.800650 Archive '00000001.history' does not exist.
postgres2_1  | 2020-04-01 22:16:26.869 GMT [1] LOG:  database system is ready to accept connections
postgres2_1  | INFO: 2020/04/01 22:16:26.931078 FILE PATH: 00000002.history.br
```

```
$ ./scripts/pg2/query.sh
 count
-------
    20
(1 row)
```