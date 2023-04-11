FROM quay.io/coreos/butane@sha256:d640f119dc531fd9806e0b729cc2f686607cb310435c5a4e5d000ad5b36306a1 as butane

COPY ./k8s/fcos-k8s-node/testing/config-bu.yaml /config.bu.yaml

RUN \
  butane --pretty --strict config.bu.yaml > /config.ign

FROM quay.io/fedora/fedora-coreos:testing@sha256:c803cc3287ba5b65c7f5ee572a63289da8d83e929b9afc186044fc9a46953e0a

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

