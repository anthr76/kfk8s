FROM quay.io/coreos/butane@sha256:b790c396c7e1bb33b85f559c7b458086ee127245b6a4ccc4140639720c85ee6d as butane

COPY ./k8s/fcos-k8s-node/config-bu.yaml /config.bu.yaml

RUN \
  butane --pretty --strict config.bu.yaml > /config.ign

FROM quay.io/fedora/fedora-coreos:stable@sha256:c5cd34e7eb493a687c282f05d36280fa44d5cd1e179ac9f5e9d613b4dbe01994

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
  systemctl enable scuttle.path kubelet-worker.path crio.service && \
  ostree container commit

LABEL org.opencontainers.image.source https://github.com/coreos/fedora-coreos-config

