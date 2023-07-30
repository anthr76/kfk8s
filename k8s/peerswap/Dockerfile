FROM docker.io/library/golang:bullseye@sha256:2ae255c69b2e96cac149ca10b02b9fd3ef71033e0187fb8c9c3c333626e5ae50 as builder

ARG VERSION
ARG CHANNEL
ARG TARGETPLATFORM


RUN \
  wget -O peerswap-${VERSION}.tar.gz -q https://github.com/ElementsProject/peerswap/archive/refs/tags/v${VERSION}.tar.gz \
  && tar xf peerswap-${VERSION}.tar.gz -C ./src \
  && rm peerswap-${VERSION}.tar.gz \
  && cd ./src/peerswap-${VERSION} \
  && mkdir /build \
  && go build -buildmode=pie -ldflags "-linkmode=external -X main.GitCommit=${VERSION}" -o /build/peerswapd ./cmd/peerswaplnd/peerswapd \
  && go build -buildmode=pie -ldflags "-linkmode=external -X main.GitCommit=${VERSION}" -o /build/pscli ./cmd/peerswaplnd/pscli \
  && chmod -R a+x /build

FROM docker.io/library/debian:bullseye-slim@sha256:fd3b382990294beb46aa7549edb9f40b11a070f959365ef7f316724b2e425f90

LABEL maintainer="Anthony Rabbito <hello@anthonyrabbito.com>"

COPY --from=builder /build/peerswapd /usr/local/bin/peerswapd
COPY --from=builder /build/pscli /usr/local/bin/pscli

ENTRYPOINT ["/usr/local/bin/peerswapd"]

LABEL org.opencontainers.image.source="https://github.com/ElementsProject/peerswap"
