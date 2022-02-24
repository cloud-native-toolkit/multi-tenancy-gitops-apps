#!/usr/bin/env bash

set -eo pipefail

# Check variables
if [ -z ${GITOPS_PK_SECRET_NAME} ]; then echo "Please set GITOPS_PK_SECRET_NAME when running script"; exit 1; fi
if [ -z ${GIT_BASEURL} ]; then echo "Please set GIT_BASEURL when running script"; exit 1; fi
if [ -z ${SSH_PRIVATE_KEY_PATH} ]; then echo "Please set SSH_PRIVATE_KEY_PATH when running script"; exit 1; fi

SEALED_SECRET_NAMESPACE=${SEALED_SECRET_NAMESPACE:-sealed-secrets}
SEALED_SECRET_CONTOLLER_NAME=${SEALED_SECRET_CONTOLLER_NAME:-sealed-secrets}

oc create secret generic \
  ${GITOPS_PK_SECRET_NAME} \
  --from-file=id_rsa="${SSH_PRIVATE_KEY_PATH}" \
  --from-literal=known_hosts="$(ssh-keyscan ${GIT_BASEURL} 2>/dev/null)" \
  --dry-run -o yaml \
  | oc label -f- \
    created-by=pipeline \
    --local \
    --dry-run -o yaml \
  | kubeseal \
    --scope cluster-wide \
    --controller-name=${SEALED_SECRET_CONTOLLER_NAME} \
    --controller-namespace=${SEALED_SECRET_NAMESPACE} \
    -o yaml > gitops-repo-pk-secret-${GITOPS_PK_SECRET_NAME}.yaml