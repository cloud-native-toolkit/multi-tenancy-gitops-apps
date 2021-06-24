#!/usr/bin/env bash

# Set variables
NAMESPACE=soapserver
SEALEDSECRET_NAMESPACE=sealed-secrets

# Create Kubernetes Secret yaml
# TO BE UDPATED

# Encrypt the secret using kubeseal and private key from the cluster
kubeseal -n ${NAMESPACE} --controller-name=sealedsecretcontroller-sealed-secrets --controller-namespace=${SEALEDSECRET_NAMESPACE} -o yaml < delete-ibm-jks-secret.yaml > ibm-jks-secret.yaml
kubeseal -n ${NAMESPACE} --controller-name=sealedsecretcontroller-sealed-secrets --controller-namespace=${SEALEDSECRET_NAMESPACE} -o yaml < delete-ibm-passwords-secret.yaml > ibm-passwords-secret.yaml


# NOTE, do not check delete-ibm-entitled-key-secret.yaml into git!
rm ibm-jks-secret.yaml
ibm-passwords-secret.yaml
