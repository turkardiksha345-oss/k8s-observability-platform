# Deployment Guide

## Prerequisites

- A Kubernetes cluster such as Kind or EKS
- kubectl configured
- Helm (optional)
- Terraform (optional for S3 provisioning)
- AWS credentials if using Amazon S3

## Installation Order

1. Apply the namespace and storage manifests.
2. Deploy Prometheus and Alertmanager.
3. Deploy Thanos components and object store secret.
4. Deploy Grafana and exporters.
5. Deploy the sample microservice.

## kubectl Installation

```bash
chmod +x scripts/install.sh
./scripts/install.sh
```

## Helm Installation

```bash
helm upgrade --install monitoring-platform ./helm -f ./helm/values.yaml
```

## Verification Commands

```bash
kubectl get pods -n monitoring
kubectl get svc -n monitoring
kubectl get statefulset -n monitoring
kubectl logs -n monitoring deploy/thanos-query
kubectl logs -n monitoring deploy/grafana
```

## Health Checks

- Prometheus UI: http://prometheus.monitoring.svc.cluster.local:9090
- Thanos Query: http://thanos-query.monitoring.svc.cluster.local:9090
- Grafana: http://grafana.monitoring.svc.cluster.local:3000

## Rollback

```bash
kubectl rollout undo statefulset/prometheus -n monitoring
kubectl rollout undo deployment/thanos-query -n monitoring
```

## Cleanup

```bash
./scripts/cleanup.sh
```
