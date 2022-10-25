FROM golang:1.19-alpine AS builder

ENV WALG_VERSION=v2.0.1
ENV BROTLI_VERSION=v1.0.9

RUN set -ex \
     && apk add --no-cache wget cmake git build-base bash

RUN set -ex \
     && cd /tmp \
     && wget -qO - https://github.com/google/brotli/archive/${BROTLI_VERSION}.tar.gz | tar xz -f '-' \
     && cd brotli* \
     && mkdir out \
     && cd out \
     && ../configure-cmake --disable-debug \
     && make \
     && make install

RUN set -ex \
     && git clone https://github.com/wal-g/wal-g/  $GOPATH/src/wal-g \
     && cd $GOPATH/src/wal-g/ \
     && git checkout $WALG_VERSION \
     && make install \
     && make deps \
     && make pg_build \
     && make link_brotli \
     && install main/pg/wal-g / \
     && /wal-g --help

FROM alpine:3.16
COPY --from=builder /wal-g /