---
title: Authorization and live-session termination
source: docs/sharing.md
source_repo: cloudflare/cloudflare-os
source_commit: 814bdc7ebe2454067b4c48e195fccd37979bb0aa
source_date: 2026-08-03
source_authors: [Phillip Jones, Kenton Varda, Dan Carter]
ingested: 2026-08-24
ingested_by: scholar
topics: [collaborative-workspace-sharing, capability-security, cloudflare-workers-agent-hosting]
status: current
---

Cloudflare OS recomputes a caller's role on every workspace open and restarts the Overseer Durable Object after a revocation so already-open sessions cannot retain stale authority.

An unreachable caller receives a workspace-access-denied result that reveals no workspace metadata. Reachable callers receive either the full or restricted capability. Since the graph is the sole source of truth, no eager storage cleanup is required for authorization correctness.

Removing or downgrading a user calls `ctx.abort()` after synchronizing the changed edge and allowing the triggering response about 100 milliseconds to leave. All clients disconnect and re-open against the new graph. Removed users reach the denial page, while downgraded users receive the restricted capability.

Source: [docs/sharing.md](https://github.com/cloudflare/cloudflare-os/blob/814bdc7ebe2454067b4c48e195fccd37979bb0aa/docs/sharing.md) at commit `814bdc7e`.
