#!/bin/bash
set -e
echo "Fetching Datadog API Key..."
DD_API_KEY=$(aws secretsmanager get-secret-value \
 --region ap-south-2 \
 --secret-id datadog/api-key \
 --query SecretString \
 --output text | jq -r '."datadog-api-key"')
echo "Fetching Cluster Agent Token..."
CLUSTER_AGENT_TOKEN=$(aws secretsmanager get-secret-value \
 --region us-east-1 \
 --secret-id datadog/cluster-agent-token \
 --query SecretString \
 --output text)
echo "API Key length: ${#DD_API_KEY}"
echo "Token length: ${#CLUSTER_AGENT_TOKEN}"
NAMESPACES=(
 datadog-agent
 guestbook
 hipster-shop
 sock-shop
 vote
)
for ns in "${NAMESPACES[@]}"
do
 echo "Creating namespace: $ns"
 kubectl create namespace "$ns" \
   --dry-run=client -o yaml | kubectl apply -f -
 echo "Creating secret in namespace: $ns"
 kubectl create secret generic datadog-secret \
   -n "$ns" \
   --from-literal=api-key="$DD_API_KEY" \
   --from-literal=token="$CLUSTER_AGENT_TOKEN" \
   --dry-run=client -o yaml | kubectl apply -f -
done
echo "Datadog secrets created successfully in all namespaces"
