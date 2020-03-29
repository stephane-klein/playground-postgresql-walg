FROM golang:1.14.1-buster AS builder

ENV WALG_VERSION=v0.2.15
ENV BROTLI_VERSION=v1.0.7

RUN set -ex \
     && apt-get update -y \
     && apt-get install --yes --no-install-recommends --no-install-suggests \
     cmake \
     liblzo2-dev \
     lzop \
     wget

RUN set -ex \
     && cd /tmp \
     && wget -qO - https://github.com/google/brotli/archive/${BROTLI_VERSION}.tar.gz | tar xz -f '-' \
     && cd brotli* \
     && mkdir out \
     && cd out \
     && ../configure-cmake --disable-debug \
     && make \
     && make install

ENV USE_LZO=1

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

FROM debian:buster
COPY --from=builder /wal-g /