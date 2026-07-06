---
source: rust/dialog-effects/README.md
source_repo: dialog-db/dialog-db
source_commit: a898b5de44a29e5be30a1faa99f11ef7a5332d69
source_date: 2026-06-04
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
section_count: 1
status: current
---

> Abstract: The README for `dialog-effects`, the crate that defines dialog-db's concrete capability hierarchy types — the domain-specific attenuations, policies, and effects (built on `dialog-capability`'s traits) that form the actual capability chains, one module per domain. Six domains are documented: **access** (`Prove`/`Retain`), **storage** (bootstrap `Location` load/create at `did:local:storage`), **space** (operator-level `Space` load/create), **archive** (content-addressed `Get`/`Put` by digest), **memory** (transactional cell `Resolve`/`Publish`/`Retract`), and **credential** (address load/save). The effects are structural types only; `dialog-storage` providers implement `Provider<Fx>` for each. This is the per-crate realization of the capability domains the `notes/repository.md` design references.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [capability-domain-effect-hierarchy](../sections/dialog-db--rust-dialog-effects-readme--capability-domain-effect-hierarchy.md) | ucan-authorization, content-addressed-storage | current |

## Provenance

- Repository default branch `main`; the file's last-touching commit is `a898b5de` (2026-06-04), authored by Irakli Gozalishvili.
- Builds on `rust/dialog-capability/README.md` (the `Subject`/`Attenuation`/`Policy`/`Effect` traits) and is consumed by `rust/dialog-storage` (the `Provider<Fx>` implementations) and `rust/dialog-operator` (the routing environment).
- Ingested in the `scholar-ingest-dialog-db-remainder-9` cycle (2026-07-06).
