#!/usr/bin/env bash

set -eo pipefail

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOTDIR="${SCRIPTDIR}/.."
[[ -n "${DEBUG:-}" ]] && set -x


if [ -z ${GIT_ORG} ]; then echo "Please set GIT_ORG when running script, optional GIT_BASEURL and GIT_REPO to formed the git url GIT_BASEURL/GIT_ORG/*"; exit 1; fi

if [ -z ${COMPONENT} ]; then echo "Please set COMPONENT when running script (ie. ace, mq)"; exit 1; fi


GIT_HOST=${GIT_HOST:-github.com}
GIT_BASEURL="https://${GIT_HOST}"
GITOPS_REPO=${GITOPS_REPO:-multi-tenancy-gitops-apps}
GITOPS_BRANCH=${GITOPS_BRANCH:-master}


find ${ROOTDIR}/${COMPONENT} -name '*.yaml' -print0 |
while IFS= read -r -d '' File; do
    if grep -q "kind: Application" "$File"; then
      sed -i'.bak' -e "s#https://github.com/cloud-native-toolkit-demos/multi-tenancy-gitops-apps.git#${GIT_BASEURL}/${GIT_ORG}/${GITOPS_REPO}#" $File
      sed -i'.bak' -e "s#targetRevision: master#targetRevision: ${GITOPS_BRANCH}#" $File
      rm "${File}.bak"
    fi
done

echo "git commit and push changes now"
