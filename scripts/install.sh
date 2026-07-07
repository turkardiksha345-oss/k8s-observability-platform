#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NAMESPACE="monitoring"

kubectl apply -f "$ROOT_DIR/kubernetes/namespace.yaml"
kubectl apply -f "$ROOT_DIR/kubernetes/storage/"
kubectl apply -f "$ROOT_DIR/kubernetes/prometheus/"
kubectl apply -f "$ROOT_DIR/kubernetes/thanos/"
kubectl apply -f "$ROOT_DIR/kubernetes/exporters/"
kubectl apply -f "$ROOT_DIR/kubernetes/grafana/"
kubectl apply -f "$ROOT_DIR/kubernetes/microservices/"

kubectl wait --namespace "$NAMESPACE" --for=condition=available --timeout=300s deployment/grafana
kubectl wait --namespace "$NAMESPACE" --for=condition=available --timeout=300s deployment/thanos-query

echo "Monitoring stack deployed successfully."
