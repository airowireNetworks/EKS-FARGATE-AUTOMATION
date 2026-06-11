#!/bin/bash

set -e

echo "Creating Datadog Secret..."
./scripts/create-secret.sh

echo "Applying RBAC..."
kubectl apply -f kubernetes/fargate-rbac.yaml

echo "Installing Datadog..."
./scripts/install-datadog.sh

echo "Patching Deployments..."
./scripts/patch-deployments.sh

echo "Restarting Deployments..."
./scripts/restart-deployments.sh

echo "Running Validation..."
./scripts/validate.sh

echo "Datadog Onboarding Completed"
