channel := "1.25"
component := "kubelet"
multiplatform := if "true" != "true" { "linux/amd64,linux/arm64" } else { "linux/amd64" }

default:
  just --list

build:
  @echo Building For:  Channel={{channel}} Component={{component}} Platform={{multiplatform}}
  #!/bin/bash
  buildah bud \
  --build-arg CHANNEL={{ channel }} \
  --build-arg VERSION=$(bash ./.github/scripts/upstream.sh "{{ component }}" "{{ channel }}") \
  --jobs 2 \
  -f ./k8s/{{component}}/Dockerfile \
  --manifest {{component}}:{{channel}} \
  .

