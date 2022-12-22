FROM docker.io/library/golang:bullseye@sha256:af894f0741cdb12c254c37419a9a46e9c75757a2a113867bc950565ccfa670a5 as builder

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

FROM docker.io/library/debian:bullseye-slim@sha256:171530d298096f0697da36b3324182e872db77c66452b85783ea893680cc1b62

LABEL maintainer="Anthony Rabbito <hello@anthonyrabbito.com>"

COPY --from=builder /build/peerswapd /usr/local/bin/peerswapd
COPY --from=builder /build/pscli /usr/local/bin/pscli

ENTRYPOINT ["/usr/local/bin/peerswapd"]

LABEL org.opencontainers.image.source="https://github.com/ElementsProject/peerswap"
