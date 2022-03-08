#!/usr/bin/env bash

# Set variables
if [[ -z ${GIT_ORG} ]]; then
  echo "Please provide environment variable GIT_ORG"
  exit 1
fi

GIT_BRANCH_SPRING=${GIT_BRANCH_SPRING:-master}

# Create Kubernetes Secret yaml
( echo "cat <<EOF" ; cat post-sync-job.yaml_template ; echo EOF ) | \
GIT_ORG=${GIT_ORG} \
GIT_BRANCH_SPRING=${GIT_BRANCH_SPRING:-master} \
sh > post-sync-job.yaml
