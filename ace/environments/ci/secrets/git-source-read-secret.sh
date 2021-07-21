#!/usr/bin/env bash

# Set variables
GIT_USER=<GIT-USER>
GIT_TOKEN=<GIT-TOKEN>
SEALEDSECRET_NAMESPACE=sealed-secrets

# Create Kubernetes Secret yaml
cat <<EOF > delete-git-source-read-creds-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: git-source-read-creds
  annotations:
    tekton.dev/git-0: https://github.com 
type: kubernetes.io/basic-auth
stringData:
  username: ${GIT_USER}
  password: ${GIT_TOKEN}
EOF

# Encrypt the secret using kubeseal and private key from the cluster
kubeseal --scope cluster-wide --controller-name=sealedsecretcontroller-sealed-secrets --controller-namespace=${SEALEDSECRET_NAMESPACE} -o yaml < delete-git-source-read-creds-secret.yaml > git-source-read-creds-secret.yaml

# NOTE, do not check delete-ibm-entitled-key-secret.yaml into git!
rm delete-git-source-read-creds-secret.yaml
