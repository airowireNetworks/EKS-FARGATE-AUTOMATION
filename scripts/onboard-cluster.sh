#!/bin/bash

set -e

echo "Creating Datadog Secret..."
./scripts/create-secret.sh

echo "Applying Fargate RBAC..."
kubectl apply -f kubernetes/fargate-rbac.yaml

echo "Creating Datadog Workload RBAC..."
./scripts/create-fargate-workload-rbac.sh

echo "Installing Datadog..."
./scripts/install-datadog.sh

echo "Patching Deployments..."
./scripts/patch-deployments.sh

echo "Restarting Deployments..."
./scripts/restart-deployments.sh

echo "Running Validation..."
./scripts/validate.sh

echo "Datadog Onboarding Completed Successfully"
