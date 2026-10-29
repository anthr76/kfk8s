FROM quay.io/coreos/butane@sha256:8d960cc42d7f2625196bc347fb6ee42540310dacd6aeddb4308f11005485e13a as butane

COPY ./k8s/fcos-k8s-node/config-bu.yaml /config.bu.yaml

RUN \
  butane --pretty --strict config.bu.yaml > /config.ign

FROM quay.io/fedora/fedora-coreos:stable@sha256:6ee2695a5598631ee8cdcb89e165641b960d6acce043f13140e37f141821a40d

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

