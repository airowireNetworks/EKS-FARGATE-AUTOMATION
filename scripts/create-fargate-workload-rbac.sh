#!/bin/bash

set -e

echo "Creating Datadog Fargate workload RBAC..."

cat <<EOF > /tmp/datadog-fargate-workloads.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: datadog-fargate-workloads
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: datadog-agent-fargate
subjects:
EOF

for ns in $(kubectl get ns -o jsonpath='{.items[*].metadata.name}')
do
  case "$ns" in
    kube-system|kube-public|kube-node-lease|default|datadog-agent)
      continue
      ;;
  esac

  cat <<EOF >> /tmp/datadog-fargate-workloads.yaml
- kind: ServiceAccount
  name: default
  namespace: $ns
EOF

done

echo "Generated RBAC:"
cat /tmp/datadog-fargate-workloads.yaml

kubectl apply -f /tmp/datadog-fargate-workloads.yaml

echo "RBAC applied successfully."
