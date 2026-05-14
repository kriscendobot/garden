---
title: Problem and original state — 512-bit identifiers were oversized and misaligned with OCapN-Noise
source: designs/daemon-256-bit-identifiers.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bcb6c379325b0f66d211d759ce7d3031fbf94e5b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [daemon, capability-security]
status: current
notes: This is the **prerequisite migration** for the locator-terminology rename ([[endo-but-for-bots--llm-designs-dlt--terminology-rename]]) — the 256-bit identifier sizes established here are what the Peer Key / Formula Address / Formula Key nomenclature renames. Marked **Complete** upstream.
---

The Endo daemon originally used **512-bit (128-character hex)**
identifiers for formula numbers, node identifiers, and content
addresses. The migration this design records reduces all of them to
**256-bit (64-character hex)**, aligning the daemon's identity scheme
with the OCapN-Noise network protocol's Ed25519 key length.

## Original state (before migration)

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

## Target state (after migration)

| Component | Size | Encoding | Source |
|---|---|---|---|
| Node / Peer ID | 256 bits | 64-char hex | **Ed25519 public key** |
| Formula Number | 256 bits | 64-char hex | Random or SHA-256 |
| Formula Identifier | 129 chars | `{number}:{node}` | Composite |
| Content Address | 256 bits | 64-char hex | SHA-256(content) |

The structural shift is the third row of the *Source* column: a node
ID is no longer *derived from* something else (SHA-512 of a rootNonce
+ "node" suffix). The node ID **is** the Ed25519 public key, which is
also what OCapN-Noise authenticates peers by. This collapses two
peer-identification schemes into one.

The migration is **breaking**: the on-disk daemon state from a
pre-migration daemon cannot be read by a post-migration daemon, and
the design explicitly says *"All test users must purge their daemon
state (`rm -rf ~/.local/state/endo/`)"*. See
[[endo-but-for-bots--llm-designs-d256--formula-types-and-security]]
for the compatibility / upgrade discussion.

See [[endo-but-for-bots--llm-designs-d256--identifier-migration-and-crypto-powers]]
for the crypto-power interface that this migration introduces.
