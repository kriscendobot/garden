---
title: Forward exclusion and sharing-change teardown
source: docs/observers.md
source_repo: cloudflare/cloudflare-os
source_commit: c6e15a0399372833405c9826f1d8764c7ebd0d76
source_date: 2026-08-04
source_authors: [Dan Carter, Kenton Varda, Nathan Disidore, Phillip Jones]
ingested: 2026-08-24
ingested_by: scholar
topics: [collaborative-workspace-sharing, capability-mediated-integrations, capability-security]
status: current
---

Forward exclusion blocks a new observation whenever a named observer remains authorized, while sharing-graph revocation permits the read and tears down obsolete observer state.

For each `excludeObservers` ID, the overseer resolves the observer record and recomputes the collaborator's live effective role. A still-authorized observer makes the observation fail. An observer who has lost all supported paths may be removed from every Gatekeeper and from overseer storage, after which the observation proceeds. Unknown IDs are inactive and ignored.

Sharing mutations similarly use their affected-collaborator set to remove records for users who became unreachable. Removal is best-effort and idempotent: stale Gatekeeper bookkeeping may cause stricter checks, but the sharing graph remains authoritative for preventing disclosure.

Source: [docs/observers.md](https://github.com/cloudflare/cloudflare-os/blob/c6e15a0399372833405c9826f1d8764c7ebd0d76/docs/observers.md) at commit `c6e15a03`.
