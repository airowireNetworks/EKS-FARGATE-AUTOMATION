#!/bin/bash

DD_API_KEY=$(aws secretsmanager get-secret-value \
  --secret-id datadog/api-key \
  --query SecretString \
  --output text)

kubectl create namespace datadog-agent \
--dry-run=client -o yaml | kubectl apply -f -

kubectl create secret generic datadog-secret \
-n datadog-agent \
--from-literal api-key="$DD_API_KEY" \
--from-literal token="$(openssl rand -hex 16)" \
--dry-run=client -o yaml | kubectl apply -f -
