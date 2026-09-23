---
title: Relationship to the Capability Map
source: doc/design/cell-capabilities.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [capability-security]
status: current
notes: This section is the explicit lineage hinge between cell-capabilities.md and cells.md / ocaps.md. The entry-type layer (this doc) and the capability-token layer (cells.md, ocaps.md, not yet ingested) are complementary, not competing; both are current.
---

Abstract: How the entry-type capability layer composes with the future cryptographic capability-token layer, the explicit reconciliation between this document and cells.md / ocaps.md. **Entry types are *structural* capabilities**: they attenuate access within the local namespace and are enforced by the CLI and any local resolver. **Capability tokens (future)** are *cryptographic* capabilities: they attenuate access across peers and are enforced by the wire protocol. The two layers compose: a remote peer presents a capability token to establish access, and the local resolver further attenuates based on the entry type, so the effective access is the **intersection (the narrower)** of the two. This is why cell-capabilities.md is a co-current lineage sibling of the earlier cell/entry docs rather than a supersession: it specifies the local-structural half of a two-layer model whose cryptographic-network half lives in cells.md and ocaps.md.

The existing design docs (CELLS.md, OCAPS.md) describe a future capability map where bearer tokens gate access to cells over the network. This proposal is complementary:

- **Entry types** are *structural* capabilities. They attenuate access within the local namespace. They are enforced by the CLI and any local resolver.
- **Capability tokens** (future) are *cryptographic* capabilities. They attenuate access across peers. They are enforced by the wire protocol.

The two layers compose. A remote peer presents a capability token to establish access; the local resolver further attenuates based on the entry type. The effective access is the intersection (narrower) of the two.

This relationship is the reason the library keeps [cells.md](cask--cells.md), [cells-and-entries.md](cask--cells-and-entries.md), and cell-capabilities.md co-`current`: the cap_token / cell_addr / capability_map machinery in cells.md is the cryptographic-network layer, and the entry-type machinery here is the structural-local layer of the same overall capability model. See the concept pages [[cask-entry-type-capability]] and [[cask-cell-bank]].

Source: [doc/design/cell-capabilities.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/cell-capabilities.md) at commit `cdb975d8`.
