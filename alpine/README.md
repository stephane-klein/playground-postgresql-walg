# POC wal-g - Archival and Restoration for Postgres

This folder contains the Debian version.

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
$ ./scripts/query-on-postgres2.sh
 count
-------
    10
(1 row)
```

=> error, it's must be `20`!