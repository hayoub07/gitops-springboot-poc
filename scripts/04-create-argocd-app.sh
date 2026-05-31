#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
kubectl create namespace demo --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd -f argocd-application-local.yaml
