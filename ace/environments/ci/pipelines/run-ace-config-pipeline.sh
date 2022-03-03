#!/usr/bin/env bash

if [ -z ${GIT_ORG} ]; then echo "Please set GIT_ORG when running script"; exit 1; fi

tkn pipeline start \
  ace-config \
  --param is-config-repo-url=git@github.com:${GIT_ORG}/ace-config.git \
  --param is-infra-repo-url=git@github.com:${GIT_ORG}/ace-infra.git \
  --param git-ops-repo-url=git@github.com:${GIT_ORG}/multi-tenancy-gitops-apps.git \
  --param gitops-apps-repo-full-name=${GIT_ORG}/multi-tenancy-gitops-apps \
  --workspace name=shared-workspace,claimName=ace-config-pvc \
  --workspace name=ace-config-repo-secret,secret=ace-config-at-github \
  --workspace name=ace-infra-repo-secret,secret=ace-infra-at-github \
  --workspace name=gitops-repo-secret,secret=multi-tenancy-gitops-apps-at-github
