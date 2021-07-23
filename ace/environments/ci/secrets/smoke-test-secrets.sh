#!/usr/bin/env bash

# Set variables
KEYSTOREPASSWORD=<keystore password>
CERT_PATH=<CERT-PATH>
SEALEDSECRET_NAMESPACE=sealed-secrets

# Create Kubernetes Secret yaml
oc create secret generic ibm-client.jks \
--from-literal=keyStorePassword=${KEYSTOREPASSWORD} \
--from-file=keyStore=${CERT_PATH}/ibm-client.jks \
--type Opaque \
--dry-run=true -o yaml > delete-ibm-client-jks-secret.yaml 

# Encrypt the secret using kubeseal and private key from the cluster
kubeseal --scope cluster-wide --controller-name=sealedsecretcontroller-sealed-secrets --controller-namespace=${SEALEDSECRET_NAMESPACE} -o yaml < delete-ibm-client-jks-secret.yaml > ibm-client-jks-secret.yaml

# NOTE, do not check delete-*-secret.yaml into git!
rm delete-ibm-client-jks-secret.yaml