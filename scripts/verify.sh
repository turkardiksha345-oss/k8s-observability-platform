#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="monitoring"

kubectl get pods -n "$NAMESPACE"
kubectl get svc -n "$NAMESPACE"
kubectl get statefulset -n "$NAMESPACE"
kubectl get deploy -n "$NAMESPACE"

kubectl port-forward -n "$NAMESPACE" svc/grafana 3000:3000 >/tmp/grafana-port-forward.log 2>&1 &
PORT_FORWARD_PID=$!
sleep 5
curl -fsS http://127.0.0.1:3000/api/health
kill "$PORT_FORWARD_PID"

echo "Verification complete."
