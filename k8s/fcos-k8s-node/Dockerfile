FROM quay.io/coreos/butane@sha256:c891b08b5b6283d5844d054ec6e57ad3bdc0523ea0bf18e25121120323e815d0 as butane

COPY ./k8s/fcos-k8s-node/config-bu.yaml /config.bu.yaml

RUN \
  butane --pretty --strict config.bu.yaml > /config.ign

FROM quay.io/fedora/fedora-coreos:stable@sha256:31560c0a6191967ff8b601684a2e82a8f9945255d81f7cdf1e6801506909fe34

COPY --from=butane /config.ign config.ign

RUN \
  rpm-ostree install crio && \
  # https://github.com/coreos/fedora-coreos-tracker/issues/1345
  rpm-ostree install amd-gpu-firmware && \
  /usr/libexec/ignition-apply config.ign && \
  rm -f config.ign && \
  rpm-ostree cleanup -m && \
  # I'm a hack
  rm -rf /var/lib/dnf/ && \
  systemctl enable scuttle.path kubelet-worker.path crio.service && \
  ostree container commit

LABEL org.opencontainers.image.source https://github.com/coreos/fedora-coreos-config

