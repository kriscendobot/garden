---
title: Single-use build admission
source: docs/architecture/production-containment-threat-model.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [sandbox-platforms, agentic-sdlc]
status: current
---

> Abstract: A trusted launcher may spend an exact build authorization only once: it checks validity and live revocation, durably consumes the authorization ID in an operator-owned replay ledger, then repeats the checks at a fresh clock observation before permitting that request.

The SQLite store serializes competitors, commits with full synchronization, and records digests of the authorization ID, full grant, and exact request. A crash or failed second check after consumption leaves the grant spent; retry requires new authority. Missing, corrupt, or unprovisioned storage refuses rather than silently creating a replay ledger, and the API offers no refund or reset.

This is an admission prerequisite, not process launch or containment. A host administrator can still roll back storage, so recovery must revoke outstanding grants before provisioning replacement state.

Source: [docs/architecture/production-containment-threat-model.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/production-containment-threat-model.md) at commit `fcc40bc`.
