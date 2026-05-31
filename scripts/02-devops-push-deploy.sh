#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
kubectl create namespace demo --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n demo -f k8s/dev/
kubectl rollout status deployment/gitops-demo -n demo
