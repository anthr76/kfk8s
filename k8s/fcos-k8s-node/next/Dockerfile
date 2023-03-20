FROM quay.io/coreos/butane@sha256:313f6986cded47480b745ccd4f5cf2b84abc5619207dea8436f1ccf9592cf56a as butane

COPY ./k8s/fcos-k8s-node/next/config-bu.yaml /config.bu.yaml

RUN \
  butane --pretty --strict config.bu.yaml > /config.ign

FROM quay.io/fedora/fedora-coreos:next@sha256:7a506202d73910a9112cfd524d057cab5aa89bcbf53aad49e6d517d6166ff009

COPY --from=butane /config.ign config.ign

ENV \
  K8S_VERSION=1.24

RUN \
  rpm-ostree ex module install cri-o:$K8S_VERSION/default && \
  # https://github.com/coreos/fedora-coreos-tracker/issues/1345
  rpm-ostree install amd-gpu-firmware && \
  /usr/libexec/ignition-apply config.ign && \
  rm -f config.ign && \
  rpm-ostree cleanup -m && \
  # I'm a hack
  rm -rf /var/lib/dnf/ && \
  ostree container commit

LABEL org.opencontainers.image.source https://github.com/coreos/fedora-coreos-config

