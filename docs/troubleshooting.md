# Troubleshooting Guide

## Prometheus Not Scraping Targets

- Check ServiceMonitor or PodMonitor definitions.
- Verify the target endpoints are reachable.
- Review Prometheus logs.

## Thanos Sidecar Cannot Upload Blocks

- Validate the S3 credentials and bucket name.
- Confirm network access to the S3 endpoint.
- Inspect sidecar logs for object store errors.

## Grafana Cannot Reach Thanos Query

- Confirm the service exists and is healthy.
- Verify the datasource URL points to the correct service name.
- Test from inside the cluster with curl.

## High Availability Issues

- Confirm two Prometheus replicas are running.
- Check cluster peer communication on port 9094.
