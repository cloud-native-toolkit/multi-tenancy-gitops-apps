#!/usr/bin/env bash

set -eo pipefail

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOTDIR="${SCRIPTDIR}/.."
[[ -n "${DEBUG:-}" ]] && set -x

pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

SEALED_SECRET_NAMESPACE=${SEALED_SECRET_NAMESPACE:-sealed-secrets}

if [ -z ${GIT_USER} ]; then echo "Please set GIT_USER when running script"; exit 1; fi

if [ -z ${GIT_TOKEN} ]; then echo "Please set GIT_TOKEN when running script"; exit 1; fi

if [ -z ${GIT_ORG} ]; then echo "Please set GIT_ORG when running script"; exit 1; fi

#if [ -z ${ARTIFACTORY_NEW_PASSWORD} ]; then echo "Please set ARTIFACTORY_NEW_PASSWORD when running script"; exit 1; fi


wait_kubeseal_ready () {
    while ! oc wait pod --timeout=-1s --for=condition=Ready -l '!job-name' -n ${SEALED_SECRET_NAMESPACE} > /dev/null; do sleep 30; done
}

mq_kubeseal_artifactory () {
    pushd $ROOTDIR/mq/environments/ci/secrets
    source artifactory-access-secret.sh
    popd
}

mq_kubeseal_git () {
    pushd $ROOTDIR/mq/environments/ci/secrets
    source git-credentials-secret.sh
    popd
}

mq_gitops_repo_cm () {
    pushd $ROOTDIR/mq/environments/ci/configmaps
    source gitops-repo-configmap.sh
    popd    
}

mq_review_git () {
    pushd $ROOTDIR/mq
    git diff
    popd
}

mq_git_add_commit_push () {
    pushd $ROOTDIR/mq
    git add .
    git commit -m "update kubseal for mq files"
    git push origin
    popd
}

# main

wait_kubeseal_ready

mq_kubeseal_artifactory

mq_kubeseal_git

mq_gitops_repo_cm

mq_review_git

mq_git_add_commit_push



