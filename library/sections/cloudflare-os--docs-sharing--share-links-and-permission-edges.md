---
title: Share links and permission edges
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

Direct grants and bearer share links become explicit permission edges, preserving how each collaborator obtained access so several independent paths can coexist.

A direct add records the sharer's profile, role, timestamp, and optional note. A share link is a durable graph node with one or more 128-bit keys. The server stores only HMAC-SHA-256 hashes of raw keys, and every copied URL mints a new key alias for the same link node.

Redeeming a key and opening the gadget occur atomically in `openGadget(id, shareKey)`. A collaborator may accumulate user and share-link edges and retains access while any valid path remains.

Source: [docs/sharing.md](https://github.com/cloudflare/cloudflare-os/blob/814bdc7ebe2454067b4c48e195fccd37979bb0aa/docs/sharing.md) at commit `814bdc7e`.
