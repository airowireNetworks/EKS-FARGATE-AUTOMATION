#!/bin/bash

set -e

# Get Datadog API Key from Secrets Manager (JSON -> value)

DD_API_KEY=$(aws secretsmanager get-secret-value \

  --region ap-south-2 \

  --secret-id datadog/api-key \

  --query SecretString \

  --output text | jq -r '."datadog-api-key"')

# Get Cluster Agent Token

CLUSTER_AGENT_TOKEN=$(aws secretsmanager get-secret-value \

  --region us-east-1 \

  --secret-id datadog/cluster-agent-token \

  --query SecretString \

  --output text)

# Ensure Datadog namespace exists

kubectl create namespace datadog-agent \

  --dry-run=client -o yaml | kubectl apply -f -

# Create secret in Datadog namespace

kubectl create secret generic datadog-secret \

  -n datadog-agent \

  --from-literal=api-key="$DD_API_KEY" \

  --from-literal=token="$CLUSTER_AGENT_TOKEN" \

  --dry-run=client -o yaml | kubectl apply -f -

# Create secret in all onboarded namespaces

for ns in datadog-agent $(./scripts/discover-namespaces.sh)

do

  echo "Creating Datadog secret in $ns"

  kubectl create secret generic datadog-secret \

    -n $ns \

    --from-literal=api-key="$DD_API_KEY" \

    --from-literal=token="$CLUSTER_AGENT_TOKEN" \

    --dry-run=client -o yaml | kubectl apply -f -

done
 
