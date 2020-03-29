# POC wal-g - Archival and Restoration for Postgres

This folder contains the Debian version.

Project status: this is a draft in work in progress.

```
$ docker-compose build wal-g
$ docker-compose build postgres
$ docker-compose up -d
$ ./scripts/load-seed.sh
$ ./scripts/insert-fixtures.sh
```

```
$ ./scripts/query-on-postgres1.sh
           email           |          created_at
---------------------------+-------------------------------
 firstname0001@example.com | 2020-03-28 13:40:47.631324+00
 firstname0002@example.com | 2020-03-28 13:40:47.631324+00
 firstname0003@example.com | 2020-03-28 13:40:47.631324+00
 firstname0004@example.com | 2020-03-28 13:40:47.631324+00
 firstname0005@example.com | 2020-03-28 13:40:47.631324+00
 firstname0006@example.com | 2020-03-28 13:40:47.631324+00
 firstname0007@example.com | 2020-03-28 13:40:47.631324+00
 firstname0008@example.com | 2020-03-28 13:40:47.631324+00
 firstname0009@example.com | 2020-03-28 13:40:47.631324+00
 firstname0010@example.com | 2020-03-28 13:40:47.631324+00
(10 rows)
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
$ docker-compose stop 
$ docker-compose exec postgres bash -c 'touch $PGDATA/recovery.signal'