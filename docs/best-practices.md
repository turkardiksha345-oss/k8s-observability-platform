# Best Practices and Optimization Recommendations

- Use Managed Prometheus or a dedicated monitoring namespace for production environments.
- Prefer external object storage with lifecycle rules and replication.
- Set resource requests and limits for all components.
- Use TLS, secrets, and least-privilege IAM policies.
- Enable alerting and retention policies that match compliance needs.
- Consider running Prometheus in a StatefulSet and using persistent storage with snapshots.
- Monitor the Thanos compactor and object storage costs.
- Add dashboards for SLOs and service-level alerts.
