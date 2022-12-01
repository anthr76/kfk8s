FROM docker.io/library/golang:bullseye as builder

ARG VERSION
ARG CHANNEL
ARG TARGETPLATFORM

RUN \
  apt-get update -qq \
  && apt-get install -qqy \
    rsync \
  && wget -O kubernetes-${VERSION}.tar.gz -q https://github.com/kubernetes/kubernetes/archive/refs/tags/v${VERSION}.tar.gz \
  && tar xf kubernetes-${VERSION}.tar.gz -C ./src \
  && rm kubernetes-${VERSION}.tar.gz \
  && cd ./src/kubernetes-${VERSION} \
  && make test WHAT=./pkg/kubelet GOFLAGS=-v \
  && ls 



LABEL org.opencontainers.image.source="https://github.com/"
