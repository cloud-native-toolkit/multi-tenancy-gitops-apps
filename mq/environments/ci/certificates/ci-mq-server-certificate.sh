#!/usr/bin/env bash

CLUSTER_DOMAIN=$(oc get dns cluster -o jsonpath='{ .spec.baseDomain }')

# Create Kubernetes Secret yaml
cat <<EOF > ci-mq-server-certificate.yaml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: ci-mq-server-cert
spec:
  dnsNames:
    - >- 
      *.${CLUSTER_DOMAIN}
  privateKey:
    algorithm: RSA
    encoding: PKCS1
    size: 2048
  usages:
    - server auth
  issuerRef:
    group: cert-manager.io
    kind: ClusterIssuer
    name: selfsigned-mq-cluster-issuer
  secretName: mq-server-cert
  subject:
    organizations:
    - ibm
EOF
