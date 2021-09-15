#!/usr/bin/env bash

CLUSTER_DOMAIN=$(oc get dns cluster -o jsonpath='{ .spec.baseDomain }')

# Create Kubernetes Secret yaml
cat <<EOF > dev-mq-client-certificate.yaml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: dev-mq-client-cert
spec:
  dnsNames:
    - >- 
      *.${CLUSTER_DOMAIN}
  privateKey:
    algorithm: RSA
    encoding: PKCS1
    size: 2048
  usages:
    - client auth
  keystores:
    jks:
      create: true
      passwordSecretRef:
        key: KEY_STORE_PASSWORD
        name: mq-client-jks-password
  issuerRef:
    group: cert-manager.io
    kind: ClusterIssuer
    name: selfsigned-mq-cluster-issuer
  secretName: mq-client-jks
  subject:
    organizations:
    - ibm
EOF
