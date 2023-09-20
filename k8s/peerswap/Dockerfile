FROM docker.io/library/golang:bullseye@sha256:572ed2238bb83dc2574925cb80f01afa076548df33853726749916c6aacf3035 as builder

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

FROM docker.io/library/debian:bullseye-slim@sha256:c618be84fc82aa8ba203abbb07218410b0f5b3c7cb6b4e7248fda7785d4f9946

LABEL maintainer="Anthony Rabbito <hello@anthonyrabbito.com>"

COPY --from=builder /build/peerswapd /usr/local/bin/peerswapd
COPY --from=builder /build/pscli /usr/local/bin/pscli

ENTRYPOINT ["/usr/local/bin/peerswapd"]

LABEL org.opencontainers.image.source="https://github.com/ElementsProject/peerswap"
