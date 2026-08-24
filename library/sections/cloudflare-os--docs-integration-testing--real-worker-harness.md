---
title: Real Worker integration-test harness
source: docs/integration-testing.md
source_repo: cloudflare/cloudflare-os
source_commit: 0d1825625808d6855c99c530affb496eb050a7d2
source_date: 2026-08-12
source_authors: [Maximo Guk]
ingested: 2026-08-24
ingested_by: scholar
topics: [testing, cloudflare-workers-agent-hosting]
status: current
---

Cloudflare OS integration tests boot the backend and Gatekeepers as real Workers in workerd, speak the same Cap'n Web WebSocket protocol as the browser, and stub only outbound HTTP.

The repository suite uses a controllable fixture Gatekeeper to test overseer observer logic. Consumer repositories are expected to reuse the parameterized harness with unmodified vendor Gatekeepers and pluggable HTTP handlers for end-to-end credential cases. Because application code executes in another process, test-runner patches do not automatically affect Worker behavior.

Source: [docs/integration-testing.md](https://github.com/cloudflare/cloudflare-os/blob/0d1825625808d6855c99c530affb496eb050a7d2/docs/integration-testing.md) at commit `0d182562`.
