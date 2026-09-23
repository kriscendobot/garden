---
title: Original state (before migration)
source: designs/daemon-256-bit-identifiers.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bcb6c379325b0f66d211d759ce7d3031fbf94e5b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [daemon, capability-security]
status: current
notes: This is the **prerequisite migration** for the locator-terminology rename ([[endo-but-for-bots--llm-designs-dlt--terminology-rename]]) — the 256-bit identifier sizes established here are what the Peer Key / Formula Address / Formula Key nomenclature renames. Marked **Complete** upstream.
parent: endo-but-for-bots--llm-designs-d256--problem-and-original-state
---

| Component | Size | Encoding | Source |
|---|---|---|---|
| Node / Peer ID | 512 bits | 128-char hex | SHA-512(rootNonce + "node") |
| Formula Number | 512 bits | 128-char hex | Random or SHA-512 |
| Formula Identifier | 257 chars | `{number}:{node}` | Composite |
| Content Address | 512 bits | 128-char hex | SHA-512(content) |

Four overlapping problems drove the migration:

1. **Excessive identifier size.** 512-bit random identifiers provided
   far more collision resistance than necessary — 2^256 is already
   astronomical; 2^512 is overhead with no security gain.
2. **Misalignment with OCapN-Noise.** The OCapN-Noise network protocol
   identifies peers by their **Ed25519 public key** (256-bit). The
   daemon's 512-bit node identifier was redundant: it could *be* the
   Ed25519 public key directly, rather than a separate SHA-512 derived
   handle that must be cross-referenced.
3. **Storage inefficiency.** Every formula path, pet store entry, and
   message reference carried 128-character hex strings where 64 would
   suffice. The cost is small per item but everywhere.
4. **SHA-256 sufficiency for content addressing.** SHA-256 provides
   128-bit collision resistance (birthday bound) and 256-bit preimage
   resistance — adequate for content-addressed blobs, more widely
   deployed than SHA-512.
