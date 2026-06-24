---
source: doc/design/caskroot-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
section_count: 3
status: current
notes: The minimal-viable concrete bootstrap root block (caskhead0). Complements ocaps.md (cask--ocaps), which sketches the fuller aspirational "ROOT (caskmap)"; caskhead0 ships only schema-version + session/membership/nursery links and defers cells/identity/consensus/pinned-roots. Sessions tie to cask--cryptography / cask--net-session-init-design; membership ties to the member-table-authorization concept.
---

> Abstract: `caskhead0`, the minimal viable first iteration of the CASK root structure — only what is essential to bootstrap a server with secure transport. The root block is a fixed-layout block with four links: a schema hash (a fixed random 32-byte value in `Links[0]` identifying the format, so `Load()` can branch on it for O(1) version detection and future migration), a sessions hash (a sessiontable root), a membership hash (a member-set root, ZeroHash when empty), and a nursery hash (ZeroHash when empty); v0 carries no bytes and legacy roots with fewer links are valid because missing links read as ZeroHash. Everything else (identity, cells, membership management, consensus, pinned roots) is deferred to future iterations or handled via cells. The API is New / Load / Get-SetSessionsRoot / Get-SetMembershipRoot, with the membership set (32-byte node_ids gating who may establish a session) backed by the membertable package and the `cask member add|rm|ls` CLI. The session-state blob packs send/recv counters, a ChaCha20-Poly1305 session key, role, mode, and best-traffic-class. Future versions get new schema hashes and a defaulted-field migration; the package lands in `go/cask/head/`.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [scope-and-structure](../sections/cask--caskroot-design--scope-and-structure.md) | content-addressed-storage, capability-security, networking | current |
| [operations-and-usage](../sections/cask--caskroot-design--operations-and-usage.md) | content-addressed-storage, networking | current |
| [versioning-and-implementation](../sections/cask--caskroot-design--versioning-and-implementation.md) | content-addressed-storage | current |

## Provenance

Source: [doc/design/caskroot-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/caskroot-design.md) at commit `cdb975d8` (2026-02-14, Kris Kowal). Ingested by scholar on 2026-06-24 (job `scholar-ingest-cask-7`, cycle 8).
