# Architecture Overview

## High-Level Flow

Application metrics are emitted by the sample microservice and scraped by Prometheus. Prometheus stores data locally in the TSDB and exposes its data to Thanos sidecars. The sidecars upload completed blocks to Amazon S3, while Thanos Query combines live data from sidecars and historical data from the Store Gateway. Grafana queries Thanos Query so users see a unified view of real-time and historical metrics.

## Why Prometheus Needs Thanos

Prometheus is excellent for local metric collection but has practical storage limits. Thanos decouples compute from storage by storing blocks in object storage and allowing Query to aggregate across multiple Prometheus instances.

## Storage Lifecycle

1. Application emits metrics.
2. Prometheus scrapes them and writes to local TSDB.
3. Thanos sidecar watches the TSDB blocks.
4. Completed blocks are uploaded to Amazon S3.
5. Store Gateway reads blocks from S3.
6. Query merges live and historical data.
7. Grafana presents the unified data set.

## Components

- Prometheus: scrape and store metrics.
- Thanos Sidecar: ships blocks to object storage.
- Thanos Store Gateway: serves object storage blocks.
- Thanos Query: unifies live and historical data.
- Grafana: dashboards and visualization.
