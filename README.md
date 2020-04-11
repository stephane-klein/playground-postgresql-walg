# wal-g - Archival and Restoration for Postgres playground based on Docker

This playground is written as small scenario:

1. start PostgreSQL instance 1
2. create a schema and insert some data to instance 1
3. create instance 1 full backup to Minio server (S3 like)
4. insert other data to instance 1
5. start and restore data to PostgreSQL instance 2
6. check all data (first backup + [WAL data](https://www.postgresql.org/docs/12/wal-intro.html))

## Some resources

- [walg-g](https://github.com/wal-g/wal-g)
- [25.3. Continuous Archiving and Point-in-Time Recovery (PITR)](https://www.postgresql.org/docs/12/continuous-archiving.html#BACKUP-PITR-RECOVERY)
- [PostgreSQL Sauvegardes et Réplication](https://public.dalibo.com/exports/formation/manuels/formations/dba3/dba3.handout.html)
- [MikeTangoEcho/postgres-walg](https://github.com/MikeTangoEcho/postgres-walg)
- [PostgreSQL WAL Archiving with WAL-G and S3: Complete Walkthrough](https://www.fusionbox.com/blog/detail/postgresql-wal-archiving-with-wal-g-and-s3-complete-walkthrough/644/)

## The test scenario

Build Docker Images:

```
$ ./scripts/build-postgres-with-wal-g-docker-image.sh
```

Start PostreSQL instance 1 and Minio (S3 like) server:

```
$ docker-compose up -d postgres1 s3
```

Wait `postgres1` starting…

Create database schema and insert some data to instance 1:

```
$ ./scripts/pg1/load-seed.sh
$ ./scripts/pg1/insert-fixtures.sh
```

Check data inserted

```
$ ./scripts/pg1/query.sh
 count
-------
    10
(1 row)
```

Create instance 1 full backup to Minio server:

```
$ ./scripts/pg1/make-basebackup.sh
```

Check PostgreSQL instance 1 stats archiver informations:

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

Insert other data (after first full backup):

```
$ ./scripts/pg1/insert-fixtures.sh
$ ./scripts/pg1/query.sh
 count
-------
    20
(1 row)
```

wait 60s and check PostgreSQL instance 1 stats archiver informations:

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

Now, the purpose is to verify the instance 1 data restoration to PostgreSQL instance 2:

```
$ ./scripts/pg2/restore.sh
```

Wait instance 2 started...

```
$ ./scripts/pg2/query.sh
 count
-------
    20
(1 row)
```

If value is 20 then full data + WAL data are restored to instance 2.

## Configure encryption and decryption with OpenPGP standard

First generate GnuPG key:

```
$ gpg2 --batch --passphrase '' --quick-gen-key wal-g-test-1
```

```
$ gpg2 -K
/Users/stephane/.gnupg/pubring.kbx
----------------------------------
...

sec   rsa2048 2020-04-04 [SC] [expire : 2022-04-04]
      576A8B01273901177B4229788C9D5E81FD721DD8
uid          [  ultime ] wal-g-test-1
ssb   rsa2048 2020-04-04 [E]
```

Export key:

```
$ mkdir -p ./keys
$ gpg2 -a --export wal-g-test-1 > ./keys/wal-g-test-1.pub
$ gpg2 -a --export-secret-keys wal-g-test-1 > ./keys/wal-g-test-1.private
```

Uncomment `WALG_PGP_KEY_PATH` variable env in `postgres1` and `postgres2` services in `docker-compose.yml`.

Next, replay « The test scenario ».