#!/bin/bash
# Performs kubectl rollout undo deployment for each deployment in deployment-tool/deployments.txt
if [ ! -f deployment-tool/deployments.txt ]; then
  echo "Nothing to roll back"
  exit 0
fi

while IFS='' read -r line || [[ -n "$line" ]]; do
  kubectl rollout undo deployment $line --namespace=$KUBE_NAMESPACE
done < "deployments.txt"
