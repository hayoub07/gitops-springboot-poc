#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../app"
mvn clean package
# Build image directly inside Minikube Docker daemon.
eval "$(minikube docker-env)"
docker build -t gitops-demo:local .
