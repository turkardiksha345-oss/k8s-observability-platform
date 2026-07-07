#!/usr/bin/env bash
set -euo pipefail

NAMESPACE="monitoring"
kubectl delete namespace "$NAMESPACE" --ignore-not-found=true

echo "Cleanup complete."
