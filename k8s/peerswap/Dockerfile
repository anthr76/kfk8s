FROM docker.io/library/golang:bullseye@sha256:4c94dfe9567ee66a0ebc35a28f9f939e9ca3a71cb2ab942359887c584da1b28e as builder

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

FROM docker.io/library/debian:bullseye-slim@sha256:924df86f8aad741a0134b2de7d8e70c5c6863f839caadef62609c1be1340daf5

LABEL maintainer="Anthony Rabbito <hello@anthonyrabbito.com>"

COPY --from=builder /build/peerswapd /usr/local/bin/peerswapd
COPY --from=builder /build/pscli /usr/local/bin/pscli

ENTRYPOINT ["/usr/local/bin/peerswapd"]

LABEL org.opencontainers.image.source="https://github.com/ElementsProject/peerswap"
