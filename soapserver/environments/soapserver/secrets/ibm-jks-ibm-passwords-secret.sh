#!/usr/bin/env bash

# Set variables
NAMESPACE=tools
SEALEDSECRET_NAMESPACE=sealed-secrets

# Create Kubernetes Secret yaml
# TO BE UDPATED
oc create secret generic ibm-passwords \
--from-literal=CLIENT_SSL_KEY_STORE_PASSWORD=passw0rd \
--from-literal=CLIENT_SSL_TRUST_STORE_PASSWORD=passw0rd \
--type Opaque \
--namespace=tools \
--dry-run=true -o yaml > delete-ibm-passwords-secret.yaml


oc create secret generic ibm-jks \
--from-file=ibm-ca.jks=/Users/Ritu.Patel@ibm.com/Desktop/ace-prod/github-ace/ace-rest-ws/certs/ibm-ca.jks \
--from-file=ibm-soap-server.jks=/Users/Ritu.Patel@ibm.com/Desktop/ace-prod/github-ace/ace-rest-ws/certs/ibm-soap-server.jks \
--type Opaque \
--namespace=tools \
--dry-run=true -o yaml > delete-ibm-jks-secret.yaml

# Encrypt the secret using kubeseal and private key from the cluster
kubeseal -n ${NAMESPACE} --controller-name=sealedsecretcontroller-sealed-secrets --controller-namespace=${SEALEDSECRET_NAMESPACE} -o yaml < delete-ibm-jks-secret.yaml > ibm-jks-secret.yaml
kubeseal -n ${NAMESPACE} --controller-name=sealedsecretcontroller-sealed-secrets --controller-namespace=${SEALEDSECRET_NAMESPACE} -o yaml < delete-ibm-passwords-secret.yaml > ibm-passwords-secret.yaml


# NOTE, do not check delete-ibm-entitled-key-secret.yaml into git!
rm delete-ibm-jks-secret.yaml
rm delete-ibm-passwords-secret.yaml
