#!/usr/bin/env bash

# Set variables
IBM_ENTITLEMENT_KEY=<ENTITLEMENT-KEY>
SEALEDSECRET_NAMESPACE=sealed-secrets

# Create Kubernetes Secret yaml
oc create secret generic ibm-entitled-registry-credentials \
--from-literal=IBM_ENTITLED_REGISTRY_USER=cp \
--from-literal=IBM_ENTITLED_REGISTRY_PASSWORD=${IBM_ENTITLEMENT_KEY} \
--dry-run=true -o yaml > delete-ibm-entitled-registry-credentials-secret.yaml

# Encrypt the secret using kubeseal and private key from the cluster
kubeseal --scope cluster-wide --controller-name=sealed-secrets --controller-namespace=${SEALEDSECRET_NAMESPACE} -o yaml < delete-ibm-entitled-registry-credentials-secret.yaml > ibm-entitled-registry-credentials-secret.yaml

# NOTE, do not check delete-ibm-entitled-key-secret.yaml into git!
rm delete-ibm-entitled-registry-credentials-secret.yaml