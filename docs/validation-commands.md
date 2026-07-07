# Validation Commands

## Prometheus Targets

```bash
kubectl port-forward -n monitoring svc/prometheus 9090:9090
curl http://127.0.0.1:9090/api/v1/targets
```

## Thanos Sidecar

```bash
kubectl logs -n monitoring statefulset/thanos-sidecar
```

## Store Gateway

```bash
kubectl logs -n monitoring deploy/thanos-store-gateway
```

## Query

```bash
kubectl logs -n monitoring deploy/thanos-query
```

## S3 Upload

```bash
aws s3 ls s3://your-metrics-bucket --recursive | head
```

## Grafana Dashboards

```bash
kubectl port-forward -n monitoring svc/grafana 3000:3000
```

## HA and Deduplication

```bash
kubectl get pods -n monitoring -l app.kubernetes.io/name=prometheus
kubectl exec -n monitoring prometheus-0 -- wget -qO- http://127.0.0.1:9090/api/v1/query?query=up
```

## Historical Queries

```bash
curl 'http://127.0.0.1:9090/api/v1/query?query=up&time=2024-01-01T00:00:00Z'
```
