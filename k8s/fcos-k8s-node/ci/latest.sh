#!/usr/bin/env bash
channel=$1

version=$(skopeo inspect docker://quay.io/fedora/fedora-coreos:${channel} | jq -r '.Labels.version')

version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"
