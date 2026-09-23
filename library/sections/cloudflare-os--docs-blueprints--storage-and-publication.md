---
title: Blueprint storage and publication
source: docs/blueprints.md
source_repo: cloudflare/cloudflare-os
source_commit: 69c39d5037609b7efe8e2ed7e704e86bb1ce7002
source_date: 2026-08-03
source_authors: [Phillip Jones, Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
topics: [reusable-app-blueprints, cloudflare-workers-agent-hosting, persistence]
status: current
---

Blueprint metadata propagates from an authoritative Gadget Durable Object through a user's listing copy to a public Workers KV record, while versioned code snapshots live separately in R2.

The Gadget DO stores the full record and a `dirty` publication flag. The User DO keeps a denormalized record so owners can list and manage Blueprints even after deleting the source gadget. Workers KV serves public lookups by Blueprint ID.

Code content is stored under `<blueprintId>/<version>` in R2 as full Yjs V2 snapshots. Old versions remain available to prevent races with concurrent instantiation. Publication sets `dirty` before propagation and clears it only after every write succeeds, leaving a visible retry path after partial failure.

Source: [docs/blueprints.md](https://github.com/cloudflare/cloudflare-os/blob/69c39d5037609b7efe8e2ed7e704e86bb1ce7002/docs/blueprints.md) at commit `69c39d50`.
