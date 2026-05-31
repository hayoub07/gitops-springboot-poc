#!/usr/bin/env bash
set -euo pipefail
kubectl port-forward svc/gitops-demo-service -n demo 8081:80
