---
title: OTEL_EXPORTER_PROMETHEUS_PORT
source: docs/env.md
source_repo: agoric/agoric-sdk
source_commit: 8051bed260133080a0d46339aefcc9baba5c1d34
source_date: 2026-03-31
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
project: agoric-sdk
topics: [tooling, repository-governance, errors]
status: current
parent: agoric-sdk--docs-env--all-vars
---

Affects: cosmic-swingset

Purpose: enabling Prometheus metrics exports

Description: When set, metrics will be exposed in the [Prometheus text-based
format](https://prometheus.io/docs/instrumenting/exposition_formats/#text-based-format)
via HTTP on this port (or the default port 9464 when the value is not a number)
for the host specified by `OTEL_EXPORTER_PROMETHEUS_HOST` (or default host
0.0.0.0) at default path "/metrics". See also
[README-telemetry.md](../packages/cosmic-swingset/README-telemetry.md#agoric-vm-swingset-metrics).

Lifetime: until we decide not to support Prometheus for metrics export

Source: [docs/env.md](https://github.com/agoric/agoric-sdk/blob/8051bed260133080a0d46339aefcc9baba5c1d34/docs/env.md) at commit `8051bed2`.
