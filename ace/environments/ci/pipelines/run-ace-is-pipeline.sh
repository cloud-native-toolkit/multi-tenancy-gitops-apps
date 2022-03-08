#!/usr/bin/env bash

if [ -z ${GIT_ORG} ]; then echo "Please set GIT_ORG when running script"; exit 1; fi

tkn -n ci pipeline start \
  ace-integration-server \
  --param is-source-repo-url=git@github.com:${GIT_ORG}/create-customer.git \
  --param is-infra-repo-url=git@github.com:${GIT_ORG}/ace-infra.git \
  --param git-ops-repo-url=git@github.com:${GIT_ORG}/multi-tenancy-gitops-apps.git \
  --param gitops-apps-repo-full-name=${GIT_ORG}/multi-tenancy-gitops-apps \
  --workspace name=shared-workspace,claimName=ace-integration-server \
  --workspace name=ace-infra-repo-secret,secret=ace-infra-at-github \
  --workspace name=gitops-repo-secret,secret=multi-tenancy-gitops-apps-at-github \
  --workspace name=ace-source-repo-secret,secret=create-customer-at-github
