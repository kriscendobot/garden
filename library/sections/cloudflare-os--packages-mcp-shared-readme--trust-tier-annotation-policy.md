---
title: MCP trust-tier annotation policy
source: packages/mcp-shared/README.md
source_repo: cloudflare/cloudflare-os
source_commit: bd0aa2dcde02008bb6170341fe2c574fd3ace275
source_date: 2026-08-18
source_authors: [Dan Carter, Maximo Guk, Nathan Disidore, Phillip Jones]
ingested: 2026-08-24
ingested_by: scholar
topics: [capability-mediated-integrations, capability-security]
status: current
---

MCP trust tiers record deployment confidence in server tool annotations, permitting read classification for user-chosen endpoints but reserving annotation-driven write auto-approval for explicitly vetted deployments.

A `byo` endpoint may use `readOnlyHint` so ordinary reads do not prompt, but no server claim can auto-apply a write. A `vetted` endpoint may combine `destructiveHint: false` and `idempotentHint: true` to qualify an action for auto-approval. Portal deployment alone is insufficient because a portal aggregates servers the administrator may not have reviewed, so it defaults to `byo` unless `MCP_PORTAL_TRUST_ANNOTATIONS=true`.

All hints are compared to explicit booleans. An unannotated tool therefore defaults to an action requiring approval and never auto-applies on either tier. Neither tier permits sharing; MCP resources remain owner-only. Account provenance is recorded separately and controls naming in approval prompts rather than annotation trust.

Source: [packages/mcp-shared/README.md](https://github.com/cloudflare/cloudflare-os/blob/bd0aa2dcde02008bb6170341fe2c574fd3ace275/packages/mcp-shared/README.md) at commit `bd0aa2dc`.
