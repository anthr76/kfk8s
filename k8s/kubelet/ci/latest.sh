#!/usr/bin/env bash
channel=$1

version=$(curl -sX GET "https://api.github.com/repos/kubernetes/kubernetes/releases" | jq --raw-output '.[] | .tag_name' | grep ${channel} | head -n 1)

version="${version#*v}"
version="${version#*release-}"
printf "%s" "${version}"
