#!/bin/bash

helm repo add datadog https://helm.datadoghq.com
helm repo update

helm upgrade --install datadog-agent \
datadog/datadog \
-f helm/datadog-values.yaml \
-n datadog-agent \
--create-namespace
