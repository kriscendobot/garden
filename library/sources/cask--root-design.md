---
source: doc/design/root-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-25
ingested_by: scholar
section_count: 5
status: current
notes: The integrating "system root" design joining network, cryptography, storage, and capability threads. caskhead0 (cask--caskroot-design) is the minimal shipped subset (schema + sessions); this document sketches the fuller future caskhead1+ root (identity, cells, membership, consensus, pinned roots, application root). Cross-references cells.md/ocaps.md (cell bank), sorted-array-design (membership), gc-and-retention (pinned roots), net-crypto/net-session-init (sessions), membership-next-steps (CASK_ROOT root user).
---

> Abstract: The CASK **system root** design, the bootstrap structure that joins the network, cryptography, storage, and capability threads. It names the **tip** (the 32-byte hash of the root block) and the **CASK_ROOT** root user (the bootstrap controller's node_id), records the implementation split (caskhead0 ships schema-version + session table; caskhead1+ adds identity, cells, membership, consensus, pinned roots), and states four design principles (self-describing, evolvable, minimal, layered). It gives the concrete link layout for v0 (schema + sessions) and the future 8-link caskhead1+ layout plus an 8-byte clustered/encrypted/authenticated feature-flags field; details the seven component structures (identity block with stable node_id, session table, cell bank as GC root, Rabin-chunked membership with a trusted subset, Raft consensus state, pinned roots, application root); walks the three bootstrap paths (fresh, existing, joining a cluster); and covers schema-versioned migration via composable zippers and the security properties for keys, sessions, capabilities, and cluster trust, closing with five open questions.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview-and-design-principles](../sections/cask--root-design--overview-and-design-principles.md) | content-addressed-storage, capability-security | current |
| [root-block-layout-and-flags](../sections/cask--root-design--root-block-layout-and-flags.md) | content-addressed-storage, capability-security, networking | current |
| [component-structures](../sections/cask--root-design--component-structures.md) | content-addressed-storage, capability-security, networking | current |
| [bootstrap-sequence](../sections/cask--root-design--bootstrap-sequence.md) | content-addressed-storage, networking | current |
| [evolution-migration-and-security](../sections/cask--root-design--evolution-migration-and-security.md) | content-addressed-storage, capability-security | current |

## Provenance

Source: [doc/design/root-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/root-design.md) at commit `cdb975d8` (2026-02-14, Kris Kowal). Ingested by scholar on 2026-06-25 (job `scholar-ingest-cask-12`, cycle 13).
