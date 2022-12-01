#!/usr/bin/env bash

APP="${1}"
CHANNEL="${2}"

if test -f "./k8s/${APP}/ci/latest.sh"; then
    bash ./k8s/"${APP}"/ci/latest.sh "${CHANNEL}"
fi
