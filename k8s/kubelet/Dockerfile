FROM docker.io/library/golang:bullseye as builder

ARG VERSION
ARG CHANNEL
ARG TARGETPLATFORM

ENV KUBE_GIT_TREE_STATE="clean"
ENV KUBE_GIT_VERSION=v${VERSION}

RUN \
  apt-get update -qq \
  && apt-get install -qqy \
    rsync \
  && wget -O kubernetes-${VERSION}.tar.gz -q https://github.com/kubernetes/kubernetes/archive/refs/tags/v${VERSION}.tar.gz \
  && tar xf kubernetes-${VERSION}.tar.gz -C ./src \
  && rm kubernetes-${VERSION}.tar.gz \
  && cd ./src/kubernetes-${VERSION} \
  # && source hack/lib/init.sh \
  # && kube::golang::setup_env \
  && make WHAT="cmd/kubelet" \
  && ls 



LABEL org.opencontainers.image.source="https://github.com/"
