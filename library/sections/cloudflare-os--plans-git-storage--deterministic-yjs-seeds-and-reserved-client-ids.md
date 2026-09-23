---
title: Deterministic Yjs seeds and reserved client IDs
source: plans/git-storage.md
source_repo: cloudflare/cloudflare-os
source_commit: 1ef6020a42fbabb6d27dd1063db3a075ba95c974
source_date: 2026-08-21
source_authors: [Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
topics: [collaborative-workspace-sharing, testing, persistence]
status: current
---

The transitional Yjs design derives byte-identical per-gadget seeds from commit trees by sorting files, using one transaction, and assigning reserved deterministic client IDs only to throwaway seed documents.

Lazy pinning requires a reserved client-ID band keyed by gadget ID because roots may be seeded at different times. Every live authoring document must stay outside that band even after Yjs collision rerolls, and the server rejects incoming updates that author inside it. Each pin carries a seed hash in both metadata and the chat log; golden-byte tests catch encoding drift. This makes replay fail loudly when seed derivation changes instead of allowing replicas to diverge silently.

Source: [plans/git-storage.md](https://github.com/cloudflare/cloudflare-os/blob/1ef6020a42fbabb6d27dd1063db3a075ba95c974/plans/git-storage.md) at commit `1ef6020a`.
