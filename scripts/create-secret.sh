#!/bin/bash
set -e
DD_API_KEY=$(aws secretsmanager get-secret-value \
 --region ap-south-2 \
 --secret-id datadog/api-key \
 --query SecretString \
 --output text)
CLUSTER_AGENT_TOKEN=$(aws secretsmanager get-secret-value \
 --region us-east-1 \
 --secret-id datadog/cluster-agent-token \
 --query SecretString \
 --output text)
kubectl create namespace datadog-agent \
 --dry-run=client -o yaml | kubectl apply -f -
kubectl create secret generic datadog-secret \
 -n datadog-agent \
 --from-literal api-key="$DD_API_KEY" \
 --from-literal token="$CLUSTER_AGENT_TOKEN" \
 --dry-run=client -o yaml | kubectl apply -f -
