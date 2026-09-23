---
source: doc/design/ocaps.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
section_count: 7
status: current
notes: The cryptographic capability-token / network layer of CASK's two-layer capability model. Co-current lineage sibling of cells.md (cask--cells), cells-and-entries.md (cask--cells-and-entries), and cell-capabilities.md (cask--cell-capabilities); cell-capabilities.md's *Relationship to the Capability Map* section names this doc explicitly as the complementary cryptographic-network half. Not a supersession. Elaborates the cap_token machinery cells.md introduces (the five-facet model answers cells.md's "read capabilities" open question).
---

> Abstract: CASK's object-capability authorization model — the cryptographic capability-token / network layer that composes with the entry-type structural-local layer (cell-capabilities.md). A capability is an unguessable 32-byte bearer token (256 bits of entropy); possession is proof of authorization, so there are no ACLs and no identity checks. The store's root is an extensible caskmap with a `"cells"` section (cell_id → per-facet capability hashes) and a `"sessions"` section (peer pubkey → cryptographic-session state), and the on-disk `.cask/` holds a NONCE that is both store identity and root capability. Each cell carries a monotonic version updated atomically with its content hash, and exposes **five facets** — read, write (always compare-and-swap), observe (persisted write-guards that push version+hash notifications over authenticated sessions), and delegate-read / delegate-write (create/revoke/list the read or write caps). Capabilities form a strict hierarchy under root_cap; ALLOC/DELETE/rotation operations plus a read/casw/observe/notify wire protocol drive cells; BATCH composes atomic multi-cell transactions via a single root CAS. Four security properties (unforgeability, attenuation, revocability, confinement) and four open questions (observer auth, delegation transitivity, expiration, audit) close the document.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview-and-root-store](../sections/cask--ocaps--overview-and-root-store.md) | capability-security, content-addressed-storage | current |
| [cell-state-and-versioning](../sections/cask--ocaps--cell-state-and-versioning.md) | capability-security, content-addressed-storage | current |
| [cell-facets-and-hierarchy](../sections/cask--ocaps--cell-facets-and-hierarchy.md) | capability-security, content-addressed-storage | current |
| [operations-and-wire-protocol](../sections/cask--ocaps--operations-and-wire-protocol.md) | capability-security, content-addressed-storage, networking | current |
| [security-properties](../sections/cask--ocaps--security-properties.md) | capability-security | current |
| [batch-operations-and-example](../sections/cask--ocaps--batch-operations-and-example.md) | capability-security, content-addressed-storage | current |
| [open-questions](../sections/cask--ocaps--open-questions.md) | capability-security | current |

## Provenance

Source: [doc/design/ocaps.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/ocaps.md) at commit `cdb975d8` (2026-02-14, Kris Kowal). Ingested by scholar on 2026-06-24 (job `scholar-ingest-cask-7`, cycle 8).
