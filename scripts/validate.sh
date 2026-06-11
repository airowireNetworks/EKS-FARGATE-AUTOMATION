#!/bin/bash

echo "===== Datadog Pods ====="
kubectl get pods -n datadog-agent

echo "===== Datadog Webhook ====="
kubectl get mutatingwebhookconfigurations | grep datadog

echo "===== Sidecar Verification ====="
kubectl get pods -A
