# POC wal-g - Archival and Restoration for Postgres

Project status: this is a draft in work in progress.

```
$ docker-compose build wal-g
$ docker-compose build postgres
$ docker-compose up postgres s3 -d
$ ./scripts/load-seed.sh
$ ./scripts/insert-fixtures.sh
```

```
$ ./scripts/query-on-postgres1.sh
 count
-------
    10
(1 row)
```

Execute first fullbackup on `postgres1`:

```
$ ./scripts/make-basebackup.sh
```


```
$ ./scripts/show_pg_stat_archiver.sh
-[ RECORD 1 ]------+------------------------------
archived_count     | 1
last_archived_wal  | 000000010000000000000001
last_archived_time | 2020-03-29 20:50:15.451962+00
failed_count       | 0
last_failed_wal    |
last_failed_time   |
stats_reset        | 2020-03-29 20:50:14.330444+00
```

```
$ ./scripts/insert-fixtures.sh
$ ./scripts/query-on-postgres1.sh
 count
-------
    20
(1 row)
```

wait 60s, next execute:

```
$ ./scripts/show_pg_stat_archiver.sh
select * from pg_stat_archiver;
-[ RECORD 1 ]------+------------------------------
archived_count     | 5
last_archived_wal  | 000000010000000000000004
last_archived_time | 2020-03-29 20:55:15.120382+00
failed_count       | 0
last_failed_wal    |
last_failed_time   |
stats_reset        | 2020-03-29 20:50:14.330444+00
```

```
$ ./scripts/restore-pg2.sh
```

```
$ docker-compose logs -f postgres2
Attaching to alpine_postgres2_1
postgres2_1  | The files belonging to this database system will be owned by user "postgres".
postgres2_1  | This user must also own the server process.
postgres2_1  |
postgres2_1  | The database cluster will be initialized with locale "en_US.utf8".
postgres2_1  | The default database encoding has accordingly been set to "UTF8".
postgres2_1  | The default text search configuration will be set to "english".
postgres2_1  |
postgres2_1  | Data page checksums are disabled.
postgres2_1  |
postgres2_1  | initdb: error: directory "/var/lib/postgresql/data" exists but is not empty
postgres2_1  | If you want to create a new database system, either remove or empty
postgres2_1  | the directory "/var/lib/postgresql/data" or run initdb
postgres2_1  | with an argument other than "/var/lib/postgresql/data".
postgres2_1  | The files belonging to this database system will be owned by user "postgres".
postgres2_1  | This user must also own the server process.
postgres2_1  |
postgres2_1  | The database cluster will be initialized with locale "en_US.utf8".
postgres2_1  | The default database encoding has accordingly been set to "UTF8".
postgres2_1  | The default text search configuration will be set to "english".
postgres2_1  |
postgres2_1  | Data page checksums are disabled.
postgres2_1  |
postgres2_1  | initdb: error: directory "/var/lib/postgresql/data" exists but is not empty
postgres2_1  | If you want to create a new database system, either remove or empty
postgres2_1  | the directory "/var/lib/postgresql/data" or run initdb
postgres2_1  | with an argument other than "/var/lib/postgresql/data".
postgres2_1  |
postgres2_1  | PostgreSQL Database directory appears to contain a database; Skipping initialization
postgres2_1  |
postgres2_1  | 2020-03-29 22:03:44.807 GMT [1] LOG:  starting PostgreSQL 12.2 on x86_64-pc-linux-musl, compiled by gcc (Alpine 9.2.0) 9.2.0, 64-bit
postgres2_1  | 2020-03-29 22:03:44.807 GMT [1] LOG:  listening on IPv4 address "0.0.0.0", port 5432
postgres2_1  | 2020-03-29 22:03:44.807 GMT [1] LOG:  listening on IPv6 address "::", port 5432
postgres2_1  | 2020-03-29 22:03:44.811 GMT [1] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
postgres2_1  | 2020-03-29 22:03:44.883 GMT [21] LOG:  database system was interrupted; last known up at 2020-03-29 22:03:27 GMT
postgres2_1  | 2020-03-29 22:03:44.885 GMT [21] LOG:  creating missing WAL directory "pg_wal/archive_status"
postgres2_1  | ERROR: 2020/03/29 22:03:48.567573 Archive '00000002.history' does not exist.
postgres2_1  | 2020-03-29 22:03:48.570 GMT [21] LOG:  starting archive recovery
postgres2_1  | 2020-03-29 22:03:48.768 GMT [21] LOG:  restored log file "000000010000000000000003" from archive
postgres2_1  | 2020-03-29 22:03:48.866 GMT [21] LOG:  redo starts at 0/3000028
postgres2_1  | 2020-03-29 22:03:48.869 GMT [21] LOG:  consistent recovery state reached at 0/3000138
postgres2_1  | 2020-03-29 22:03:48.870 GMT [1] LOG:  database system is ready to accept read only connections
postgres2_1  | ERROR: 2020/03/29 22:03:48.915514 Archive '000000010000000000000004' does not exist.
postgres2_1  | 2020-03-29 22:03:48.918 GMT [21] LOG:  redo done at 0/3000138
postgres2_1  | 2020-03-29 22:03:49.183 GMT [21] LOG:  restored log file "000000010000000000000003" from archive
postgres2_1  | ERROR: 2020/03/29 22:03:49.251180 Archive '00000002.history' does not exist.
postgres2_1  | 2020-03-29 22:03:49.254 GMT [21] LOG:  selected new timeline ID: 2
postgres2_1  | 2020-03-29 22:03:50.045 GMT [21] LOG:  archive recovery complete
postgres2_1  | ERROR: 2020/03/29 22:03:50.089055 Archive '00000001.history' does not exist.
postgres2_1  | 2020-03-29 22:03:50.151 GMT [1] LOG:  database system is ready to accept connections
postgres2_1  | INFO: 2020/03/29 22:03:50.208375 FILE PATH: 00000002.history.br
```

```
$ ./scripts/query-on-postgres2.sh
 count
-------
    10
(1 row)
```

=> error, it's must be `20`!