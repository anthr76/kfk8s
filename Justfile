CHANNEL := "1.25"
COMPONENT := "kubelet"
REGISTRY := "ghcr.io"
USERNAME := "anthr76"
REGISTRY_AND_USERNAME := REGISTRY/USERNAME
MULTIPLATFORM := "false"

_default:
    @just --list --list-heading $'Example: just CHANNEL=1.24 COMPONENT=kubelet build \n'

# Builds a container to containers-storage under the manifest COMPONENT:CHANNEL
build:
    @echo Building For: Channel={{ CHANNEL }} Component={{ COMPONENT }} Platform=`just _get_build_platform`
    #!/bin/bash
    set -euxo pipefail
    buildah bud \
    --build-arg CHANNEL={{ CHANNEL }} \
    --build-arg VERSION=`just _get_upstream_version` \
    --jobs 4 \
    --platform `just _get_build_platform` \
    -f `just _get_build_dockerfile` \
    --manifest {{ COMPONENT }}:{{ CHANNEL }} \
    --label `just _get_build_label_type` \
    --label `just _get_build_label_type`.created="`date --rfc-3339=seconds --utc`" \
    --label `just _get_build_label_type`.title="{{COMPONENT}} ({{ CHANNEL }})" \
    --label `just _get_build_label_type`.version="`just _get_upstream_version`" \
    --label `just _get_build_label_type`.authors="`git config user.name` <`git config user.email`>" \
    --label `just _get_build_label_type`.url="https://github.com/anth76/kfk8s/k8s/{{ COMPONENT }}" \
    --label `just _get_build_label_type`.documentation="https://github.com/anth76/kfk8s/k8s/{{ COMPONENT }}/README.md" \
    --label `just _get_build_label_type`.revision="`git describe --always --dirty`" \
    .
# Pushes a built image to specified registry.
build-push: _build-tag
    buildah manifest push --all {{REGISTRY_AND_USERNAME}}/`just _get_image`:`just _get_upstream_version` docker://{{REGISTRY_AND_USERNAME}}/`just _get_image`:`just _get_upstream_version`
    buildah manifest push --all {{REGISTRY_AND_USERNAME}}/`just _get_image`:`just _get_upstream_version` docker://{{REGISTRY_AND_USERNAME}}/`just _get_image`:rolling 

_build-tag: build
    buildah tag {{ COMPONENT }}:{{ CHANNEL }} {{REGISTRY_AND_USERNAME}}/`just _get_image`:`just _get_upstream_version`
    buildah tag {{ COMPONENT }}:{{ CHANNEL }} {{REGISTRY_AND_USERNAME}}/`just _get_image`:rolling

_get_upstream_version:
    ./.github/scripts/upstream.sh {{ COMPONENT }} {{ CHANNEL }}

_get_image:
    #!/bin/bash
    set -euxo pipefail
    if [[ `just _get_is_stable` == true ]]; then
        echo {{ COMPONENT }}
    else
        echo {{ COMPONENT }}-{{ CHANNEL }}
    fi

_get_channel_config:
   echo $(jq --arg chan "{{ CHANNEL }}" '(.channels | .[] | select(.name == $chan))' ./k8s/{{ COMPONENT }}/metadata.json)

_get_is_stable:
   echo $(jq --raw-output '.stable' <<< `just _get_channel_config`) 

_get_build_platform:
    #!/bin/bash
    set -euxo pipefail
    if [[ {{MULTIPLATFORM}} == true ]]; then
        echo $(jq --raw-output '.platforms | join(",")' <<< `just _get_channel_config`)
    else
        echo "linux/$(podman info -f json | jq -r '.host.arch')"
    fi

_get_build_label_type:
    #!/bin/bash
    set -euxo pipefail
    if [[ $(jq '.base' ./k8s/{{ COMPONENT }}/metadata.json) == true ]]; then
        echo org.opencontainers.image.base
    else
        echo org.opencontainers.image
    fi

_get_build_dockerfile:
    #!/bin/bash
    set -euxo pipefail
    if test -f "./k8s/{{ COMPONENT }}/{{ CHANNEL }}/Dockerfile"; then
        echo './k8s/{{ COMPONENT }}/{{ CHANNEL }}/Dockerfile'
    else
        echo './k8s/{{ COMPONENT }}/Dockerfile'
    fi

