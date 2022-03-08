#!/usr/bin/env bash

set -eo pipefail

# Check variables
if [ -z ${IBM_ENTITLEMENT_KEY} ]; then echo "Please set IBM_ENTITLEMENT_KEY when running script"; exit 1; fi

SEALED_SECRET_NAMESPACE=${SEALED_SECRET_NAMESPACE:-sealed-secrets}
SEALED_SECRET_CONTOLLER_NAME=${SEALED_SECRET_CONTOLLER_NAME:-sealed-secrets}

oc create secret docker-registry \
  ibm-entitlement-key \
  --docker-username=cp \
  --docker-server=cp.icr.io \
  --docker-password=${IBM_ENTITLEMENT_KEY} \
  --dry-run -o yaml \
  | oc label -f- \
    created-by=pipeline \
    --local \
    --dry-run -o yaml \
  | kubeseal \
    --scope cluster-wide \
    --controller-name=${SEALED_SECRET_CONTOLLER_NAME} \
    --controller-namespace=${SEALED_SECRET_NAMESPACE} \
    -o yaml > ibm-entitlement-key-secret.yaml