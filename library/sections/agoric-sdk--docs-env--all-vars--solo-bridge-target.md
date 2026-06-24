---
title: SOLO_BRIDGE_TARGET
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

Affects: solo

This enables a proxy so that the solo bridge interface (/wallet-bridge.html) is backed by the smart wallet (/wallet/bridge.html). Dapps designed for the solo bridge can enable this until they connect to the smart wallet directly.

```sh
BRIDGE_TARGET=http://localhost:3001 make BASE_PORT=8002 scenario3-run
```

Lifetime: smart wallet transition period

Source: [docs/env.md](https://github.com/agoric/agoric-sdk/blob/8051bed260133080a0d46339aefcc9baba5c1d34/docs/env.md) at commit `8051bed2`.
