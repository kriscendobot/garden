---
source: designs/daemon-checkin-checkout.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-checkin-checkout.md
source_path: designs/daemon-checkin-checkout.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - tooling
  - capability-security
genre: §endo-but-for-bots-design
cycle: 168
lane: designs
status: current
title: §Decision-3-readable-tree-stores-formula-IDs-not-content-hashes
parent: endo-but-for-bots--llm-designs-daemon-checkin-checkout--bidirectional-bridge-between-local-FS-and-formula-store-with-CLI-side-formulation
---

> *Each entry in the tree points to a formula identifier
> (which may be a `readable-blob` or a nested
> `readable-tree`). The content hash is one level of
> indirection away, inside the `readable-blob` formula.
> This preserves the formula graph for GC and allows the
> same content hash to back multiple formulas with
> different identities.*

§Identity-vs-content distinction. §Formula-graph-for-GC
needs identity edges, not just content edges. §Two-blobs-
with-same-content-can-be-distinct-formulas (e.g., owned by
different pet stores; different lifetimes).

§Content-deduplication-still-happens at the store-sha256
layer; §formula-identity-deduplication-doesn't (each
checkin produces fresh formula numbers even for repeated
content).

§The-content-hash-is-one-level-of-indirection-away. §Cycle-
141's-daemon-cas-management uses the same shape: the
content store is keyed by SHA-256; formulas reference store
entries by hash but have their own identity.
