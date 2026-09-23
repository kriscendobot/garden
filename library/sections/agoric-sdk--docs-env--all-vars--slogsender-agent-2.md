---
title: SLOGSENDER_AGENT_*
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

A `SLOGSENDER_AGENT_` prefix may be used to set variables in the environment of
slog sender modules. The name prefix is stripped, allowing slog senders to see a
different value for e.g.
[`OTEL_EXPORTER_PROMETHEUS_PORT`](#otel_exporter_prometheus_port).

Source: [docs/env.md](https://github.com/agoric/agoric-sdk/blob/8051bed260133080a0d46339aefcc9baba5c1d34/docs/env.md) at commit `8051bed2`.
