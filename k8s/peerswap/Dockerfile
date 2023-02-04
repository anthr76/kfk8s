FROM docker.io/library/golang:bullseye@sha256:a5336c860124867f61687e95bc7fe15974fd0d5a2efded477965a793e2ab9038 as builder

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

FROM docker.io/library/debian:bullseye-slim@sha256:d51d5c391d202d5e2e0294a9df6ff077ed40583b11831d347d418690da496c50

LABEL maintainer="Anthony Rabbito <hello@anthonyrabbito.com>"

COPY --from=builder /build/peerswapd /usr/local/bin/peerswapd
COPY --from=builder /build/pscli /usr/local/bin/pscli

ENTRYPOINT ["/usr/local/bin/peerswapd"]

LABEL org.opencontainers.image.source="https://github.com/ElementsProject/peerswap"
