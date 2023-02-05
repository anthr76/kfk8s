FROM docker.io/library/golang:bullseye@sha256:224fa62f42c1ea495a13a9ffb9862ce3be7b93424ecdf4795859077df0413d2b as builder

ARG VERSION
ARG CHANNEL
ARG TARGETPLATFORM

ENV KUBE_GIT_TREE_STATE="clean"

RUN \
  apt-get update -qq \
  && apt-get install -qqy \
    rsync \
  && wget -O kubernetes-${VERSION}.tar.gz -q https://github.com/kubernetes/kubernetes/archive/refs/tags/v${VERSION}.tar.gz \
  && tar xf kubernetes-${VERSION}.tar.gz -C ./src \
  && rm kubernetes-${VERSION}.tar.gz \
  && cd ./src/kubernetes-${VERSION} \
  && make WHAT="cmd/kubelet"

FROM us.gcr.io/k8s-artifacts-prod/build-image/debian-iptables:bullseye-v1.5.1@sha256:04bfcd818ffc2c6a880c8d3987c932098c32fd412de192b5e7fd0ae768b94781
LABEL maintainer="Anthony Rabbito <hello@anthonyrabbito.com>"

RUN clean-install --allow-change-held-packages libcap2
RUN clean-install \
  bash \
  ca-certificates \
  ceph-common \
  cifs-utils \
  e2fsprogs \
  xfsprogs \
  ethtool \
  glusterfs-client \
  iproute2 \
  jq \
  nfs-common \
  socat \
  udev \
  util-linux

COPY --from=builder /go/src/kubernetes-*/_output/bin/kubelet /usr/local/bin/kubelet
ENTRYPOINT ["/usr/local/bin/kubelet"]

LABEL org.opencontainers.image.source="https://github.com/kubernetes/kubernetes"
