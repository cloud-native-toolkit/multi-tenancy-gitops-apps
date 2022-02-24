#!/usr/bin/env bash

set -eo pipefail

# Check variables
if [ -z ${TOKEN_SECRET_NAME} ]; then echo "Please set TOKEN_SECRET_NAME when running script"; exit 1; fi
if [ -z ${TOKEN} ]; then echo "Please set TOKEN when running script"; exit 1; fi

SEALED_SECRET_NAMESPACE=${SEALED_SECRET_NAMESPACE:-sealed-secrets}
SEALED_SECRET_CONTOLLER_NAME=${SEALED_SECRET_CONTOLLER_NAME:-sealed-secrets}

envsubst < gitops-repo-token-secret-template.yaml | kubeseal \
  --scope cluster-wide \
  --controller-name=${SEALED_SECRET_CONTOLLER_NAME} \
  --controller-namespace=${SEALED_SECRET_NAMESPACE} \
  -o yaml > github-user-token-secret-${TOKEN_SECRET_NAME}.yaml
