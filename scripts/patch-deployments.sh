#!/bin/bash

for ns in $(./scripts/discover-namespaces.sh)
do
    echo "Processing namespace: $ns"

    kubectl get deploy -n $ns -o name | while read deploy
    do

        kubectl patch $deploy \
        -n $ns \
        --type merge \
        -p '{
          "spec": {
            "template": {
              "metadata": {
                "labels": {
                  "agent.datadoghq.com/sidecar":"fargate"
                }
              }
            }
          }
        }'

    done
done
