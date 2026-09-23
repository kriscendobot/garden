---
title: Lazy revocation and restoration
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

Revocation severs supporting edges and recomputes reachability instead of cascading deletion through downstream collaborator records, making restoration possible by reconnecting a prior path.

Removing a collaborator deletes the relevant incoming grants while preserving that collaborator's outgoing grants. Revoking a link sets a flag while retaining the node and references. A downstream user with no remaining owner-rooted path becomes unreachable at the next authorization check.

Because records are not pruned, re-adding a removed intermediary restores both their access and any dependent paths. Before confirmation, preview RPCs compare role maps with and without a proposed change. `keepUsers` may re-root selected dependents by adding direct edges at their prior roles, bounded by the caller's grant authority.

Source: [docs/sharing.md](https://github.com/cloudflare/cloudflare-os/blob/814bdc7ebe2454067b4c48e195fccd37979bb0aa/docs/sharing.md) at commit `814bdc7e`.
