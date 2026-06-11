#!/bin/bash

kubectl get ns -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' \
| grep -v kube-system \
| grep -v kube-public \
| grep -v kube-node-lease \
| grep -v datadog-agent
