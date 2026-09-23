---
title: Commit-backed chat merge and migration
source: plans/git-storage.md
source_repo: cloudflare/cloudflare-os
source_commit: 1ef6020a42fbabb6d27dd1063db3a075ba95c974
source_date: 2026-08-21
source_authors: [Kenton Varda]
ingested: 2026-08-24
ingested_by: scholar
topics: [persistence, collaborative-workspace-sharing, ai-generated-apps]
status: current
---

Chat branches merge into themselves before mainline advances: an accept is always a fast-forward from the current gadget head, while a moved mainline is incorporated through an explicit three-way merge whose result returns to the chat for review and conflict cleanup.

The design rejects Yjs CRDT merging across divergent Git bases. Instead it compares the recorded merged commit, current head, and chat tree per path, leaving diff3 markers for true conflicts. Migration synthesizes commits from the historical Yjs update log at meaningful merge points, batches quiet editing bursts, backfills chat messages with commit identities, and retains old `code` and `snapshots` collections read-only during transition. Gadget, blueprint, and UI readers move to commit trees, and standalone mainline editing disappears.

Source: [plans/git-storage.md](https://github.com/cloudflare/cloudflare-os/blob/1ef6020a42fbabb6d27dd1063db3a075ba95c974/plans/git-storage.md) at commit `1ef6020a`.
