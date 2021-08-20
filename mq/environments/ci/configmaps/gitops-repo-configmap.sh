#!/usr/bin/env bash

# Set variables
if [[ -z ${GIT_ORG} ]]; then
  echo "Please provide environment variable GIT_ORG"
  exit 1
fi

# Create Kubernetes Secret yaml
cat <<EOF > gitops-repo-configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  labels:
    app: multi-tenancy-gitops
    group: pipeline
    type: git
  name: gitops-repo
data:
  branch: ocp47-2021-2
  host: github.com
  org: ${GIT_ORG}
  owner: ${GIT_ORG}
  parentdir: .
  protocol: https
  repo: multi-tenancy-gitops-apps
  url: https://github.com/${GIT_ORG}/multi-tenancy-gitops-apps.git
EOF
