#!/bin/bash

for ns in $(./scripts/discover-namespaces.sh)
do
  echo "Restarting deployments in namespace: $ns"

  kubectl rollout restart deployment -n $ns || true
done
