# POC wal-g - Archival and Restoration for Postgres

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
$ docker-compose exec postgres bash -c '/wal-g backup-push -f $PGDATA'
```

```
postgres=# select * from pg_stat_archiver \gx
-[ RECORD 1 ]------+-----------------------------------------
archived_count     | 3
last_archived_wal  | 000000010000000000000002.00000060.backup
last_archived_time | 2020-03-28 13:41:22.281225+00
failed_count       | 0
last_failed_wal    |
last_failed_time   |
stats_reset        | 2020-03-28 13:40:03.726216+00
```


```
$ docker-compose stop 
$ docker-compose exec postgres bash -c 'touch $PGDATA/recovery.signal'