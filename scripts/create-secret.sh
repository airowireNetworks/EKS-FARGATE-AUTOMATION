#!/bin/bash
set -e
DD_API_KEY=$(aws secretsmanager get-secret-value \
 --region ap-south-2 \
 --secret-id datadog/api-key \
 --query SecretString \
 --output text | jq -r '.["datadog-api-key"]')
CLUSTER_AGENT_TOKEN=$(aws secretsmanager get-secret-value \
 --region us-east-1 \
 --secret-id datadog/cluster-agent-token \
 --query SecretString \
 --output text)
NAMESPACES=(
 datadog-agent
 guestbook
 hipster-shop
 sock-shop
 vote
)
for ns in "${NAMESPACES[@]}"
do
 kubectl create namespace "$ns" \
   --dry-run=client -o yaml | kubectl apply -f -
 kubectl create secret generic datadog-secret \
   -n "$ns" \
   --from-literal=api-key="$DD_API_KEY" \
   --from-literal=token="$CLUSTER_AGENT_TOKEN" \
   --dry-run=client -o yaml | kubectl apply -f
done
echo "Datadog secrets created in all namespaces"
