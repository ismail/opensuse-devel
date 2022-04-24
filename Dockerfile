# syntax=docker/dockerfile:1.4

FROM opensuse/tumbleweed

ARG GOSU_VERSION=1.14
ARG TARGETPLATFORM

RUN zypper --non-interactive refresh
RUN zypper --non-interactive install --no-confirm --no-recommends \
            bsdtar ca-certificates clang13 cpio curl gcc12 gcc12-c++ gdb go1.18 \
            less libc++-devel llvm13 openssl-3 pkgdiff python310 openssh-clients procps \
            ruby3.1-rubygem-pry strace vim zsh zstd

RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then ARCHITECTURE=amd64; elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then ARCHITECTURE=arm64; fi \
    && curl -sS -L https://github.com/tianon/gosu/releases/download/"$GOSU_VERSION"/gosu-"$ARCHITECTURE" | install /dev/stdin /usr/local/bin/gosu

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

COPY files/ /
RUN  chmod 0755 /entrypoint
ENTRYPOINT ["/entrypoint"]
