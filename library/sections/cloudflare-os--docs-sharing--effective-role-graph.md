---
title: Effective roles over a permission graph
source: docs/sharing.md
source_repo: cloudflare/cloudflare-os
source_commit: 814bdc7ebe2454067b4c48e195fccd37979bb0aa
source_date: 2026-08-03
source_authors: [Phillip Jones, Kenton Varda, Dan Carter]
ingested: 2026-08-24
ingested_by: scholar
topics: [collaborative-workspace-sharing, capability-security]
status: current
---

Effective access is the maximum role reachable from the owner through a graph whose edges cannot grant more authority than their supporting sharer currently holds.

The owner is an implicit `build` root. Each direct or link edge grants the lesser of its declared role and the sharer's effective role, and a collaborator receives the maximum across valid incoming edges. Share links are supported by their creators, so removing a creator also invalidates paths through that creator's links.

`computeEffectiveRoles()` repeatedly propagates increasing roles until a fixed point. The computation handles deep chains, diamonds, and cycles, and supports hypothetical removals, edge deletions, link revocations, and role overrides for previewing a change.

Source: [docs/sharing.md](https://github.com/cloudflare/cloudflare-os/blob/814bdc7ebe2454067b4c48e195fccd37979bb0aa/docs/sharing.md) at commit `814bdc7e`.
