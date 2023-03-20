FROM quay.io/coreos/butane@sha256:313f6986cded47480b745ccd4f5cf2b84abc5619207dea8436f1ccf9592cf56a as butane

COPY ./k8s/fcos-k8s-node/testing/config-bu.yaml /config.bu.yaml

RUN \
  butane --pretty --strict config.bu.yaml > /config.ign

FROM quay.io/fedora/fedora-coreos:testing@sha256:571f01a4f0adaf578fadbca69f8f7660e64854d9aa00bf7dbc4f9724bbdbee1c

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

