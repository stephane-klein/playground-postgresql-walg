FROM golang:1.14.1-buster AS builder

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
