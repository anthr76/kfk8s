FROM quay.io/coreos/butane@sha256:10816a789b795cf15edca5440f79572fc47fee50e4ae27ea6abaf79ad2f37bde as butane

COPY ./k8s/fcos-k8s-node/next/config-bu.yaml /config.bu.yaml

RUN \
  butane --pretty --strict config.bu.yaml > /config.ign

FROM quay.io/fedora/fedora-coreos:next@sha256:c8b5d62ff20a1ce03cc2958a210f8e5972b1246b89745e8c466e6801ea8f999c

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

