---
id: cask-cell-facets
aliases: ["cell facets", "five facets", "read facet", "write facet", "observe facet", "delegate-read facet", "delegate-write facet", "read_cap", "write_cap", "observe_cap", "delegate_read_cap", "delegate_write_cap", "root_cap", "capability token", "bearer token capability", "32-byte capability", "cap rotation", "capability rotation", "ALLOC cell", "BATCH operations", "casw", "observe packet", "notify packet", "cell version", "monotonic version", "capability hierarchy"]
topics: [capability-security, content-addressed-storage]
status: current
---

# cask-cell-facets

CASK's **cryptographic capability-token model** for cells (ocaps.md): the cryptographic-network half of the two-layer capability model whose structural-local half is the entry-type layer ([[cask-entry-type-capability]]). A **capability** is an unguessable 32-byte bearer token (256 bits of entropy); possession is proof of authorization, so there are no ACLs and no identity checks. Each cell carries a **monotonic `uint64` version** updated atomically with its content hash (buying ordering, consistency, and caching), and exposes **five facets**, each gated by a separate capability: **read** (`content_hash, version`), **write** (always compare-and-swap: present old+new hash, succeed only on match, version increments), **observe** (register persisted write-guards so the cell pushes `(version, content_hash)` notifications to peers over authenticated sessions), and **delegate-read** / **delegate-write** (each can create / revoke / list the read or write capabilities for that cell). The capabilities form a strict **hierarchy** under `root_cap`: root allocates/deletes/lists cells; per cell, `delegate_write_cap` (which implies delegate-read authority) and `delegate_read_cap` manage the individual write/read caps and `observe_cap` manages observers; authority only narrows downward. Operations are `ALLOC` (mint cell + facets), `DELETE`, atomic capability **rotation** (CAS on the cell's caskmap entry, no migration window), and `BATCH` (atomic multi-cell transaction via one root-hash CAS). The wire protocol is `read` / `casw` / `observe` / `notify` packets. Four security properties hold: unforgeability, attenuation (`write_cap > observe_cap > read_cap`), revocability, confinement.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cask--ocaps--overview-and-root-store](../sections/cask--ocaps--overview-and-root-store.md) | The ocap model, the extensible ROOT caskmap (cells/sessions sections), and the .cask/ on-disk layout with the dual-purpose NONCE. |
| [cask--ocaps--cell-state-and-versioning](../sections/cask--ocaps--cell-state-and-versioning.md) | Cell state is content_hash + a monotonic version updated atomically; ordering, consistency, caching. |
| [cask--ocaps--cell-facets-and-hierarchy](../sections/cask--ocaps--cell-facets-and-hierarchy.md) | The five facets, the per-cell caskmap entry (read/write as sets), and the root_cap → delegate → individual hierarchy. |
| [cask--ocaps--operations-and-wire-protocol](../sections/cask--ocaps--operations-and-wire-protocol.md) | ALLOC/DELETE/rotation operations and the read/casw/observe/notify wire packets. |
| [cask--ocaps--security-properties](../sections/cask--ocaps--security-properties.md) | Unforgeability, attenuation, revocability, confinement. |
| [cask--ocaps--batch-operations-and-example](../sections/cask--ocaps--batch-operations-and-example.md) | Atomic multi-cell BATCH via one root CAS; the collaborative-document facet-sharing example. |
| [cask--ocaps--open-questions](../sections/cask--ocaps--open-questions.md) | Observer authentication, delegation transitivity, capability expiration, audit logging. |

## See also

- [[cask-cell-bank]] — the cell-graph layer ocaps.md elaborates; `cap_token` / `cell_addr` / `value_hash` are the bank's machinery, and the five facets answer cells.md's "read capabilities" open question.
- [[cask-entry-type-capability]] — the structural-local capability layer; effective access is the **intersection** of an entry type (this layer) and a capability token (that layer).
- [[cask-caskhead-root]] — the concrete bootstrap root block; ocaps.md's "ROOT (caskmap)" is the aspirational fuller form.
- [[object-capability]] — the general ocap model these tokens instantiate.
- [[principle-of-least-authority]] — the five facets and the narrowing hierarchy are POLA applied to a mutable cell.
- [[member-table-authorization]] — casknet's peer-admission capability layer, adjacent cryptographic ocap machinery.
