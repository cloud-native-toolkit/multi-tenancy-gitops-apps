#!/usr/bin/env bash

# Set variables
if [[ -z ${IBM_ENTITLEMENT_KEY} ]]; then
  echo "Please provide environment variable IBM_ENTITLEMENT_KEY"
  exit 1
fi

IBM_ENTITLEMENT_KEY=${IBM_ENTITLEMENT_KEY}

SEALED_SECRET_NAMESPACE=${SEALED_SECRET_NAMESPACE:-sealed-secrets}
SEALED_SECRET_CONTOLLER_NAME=${SEALED_SECRET_CONTOLLER_NAME:-sealed-secrets}

# Create Kubernetes Secret yaml
oc create secret docker-registry ibm-entitlement-key \
--docker-username=cp \
--docker-password=${IBM_ENTITLEMENT_KEY} \
--docker-server=cp.icr.io \
--dry-run=true -o yaml > delete-ibm-entitlement-key-secret.yaml

# Encrypt the secret using kubeseal and private key from the cluster
kubeseal -n tools --controller-name=${SEALED_SECRET_CONTOLLER_NAME} --controller-namespace=${SEALED_SECRET_NAMESPACE} -o yaml < delete-ibm-entitlement-key-secret.yaml > ibm-entitlement-key-secret.yaml

# NOTE, do not check delete-ibm-entitled-key-secret.yaml into git!
rm delete-ibm-entitlement-key-secret.yaml