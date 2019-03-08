FROM alpine:edge as builder

# cjose fails for now it seems
RUN apk add --no-cache --virtual .build-deps \
  build-base openssl-dev make tcl-dev pcre-dev zlib-dev \
  file perl libexecinfo-dev sed linux-headers libunwind-dev \
  brotli-dev jansson-dev luajit-dev readline-dev geoip-dev \
  git automake libtool autoconf libressl-dev curl git wget tzdata \
  && cp -r -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
  && echo "Asia/Shanghai" > /etc/timezone

RUN git clone https://github.com/apache/trafficserver.git \
  && cd trafficserver \
  && wget https://patch-diff.githubusercontent.com/raw/apache/trafficserver/pull/5115.diff \
  && patch -p1 < 5115.diff \
  && autoreconf -if \
  && ./configure --enable-experimental-plugins --disable-hwloc \
  && make \
  && make check
