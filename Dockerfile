FROM alpine as builder

RUN apk add --no-cache \
    alpine-sdk \
    linux-headers \
    git \
    zlib-dev \
    openssl-dev \
    gperf \
    cmake \
    php \
    php-ctype

WORKDIR /tmp/_build_tdlib/

RUN git clone https://github.com/tdlib/td.git /tmp/_build_tdlib/ --branch v1.6.0

RUN mkdir build
WORKDIR /tmp/_build_tdlib/build/

RUN cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=../tdlib ..
RUN cmake --build . --target prepare_cross_compiling

WORKDIR /tmp/_build_tdlib/
RUN php SplitSource.php
WORKDIR /tmp/_build_tdlib/build

RUN cmake --build . --target install

WORKDIR /tmp/_build_tdlib/
RUN php SplitSource.php --undo


FROM alpine

COPY --from=builder /tmp/_build_tdlib/tdlib/ /tdlib/