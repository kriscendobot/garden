---
source: designs/daemon-endo-rust-sqlite.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-endo-rust-sqlite.md
section_kind: design
ingested: 2026-06-05
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - persistence
status_at_ingest: Complete
genre: §endo-but-for-bots-design §host-function-package-for-XS-rust
cycle: 194
lane: designs
status: current
title: §The-§passable-by-construction-discipline (the design anchor)
parent: endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite--re-prepare-instead-of-caching-Statement-and-FFI-tag-encoding-confined-to-internal-plumbing-and-passable-by-construction
---

```
The key constraint is that all values returned by the SQLite
bindings must be passable — expressible by Endo's marshalling.

| SQLite type | JS type | Notes |
|-------------|---------|-------|
| NULL | `null` | |
| INTEGER | `bigint` | Always bigint, even for small values |
| REAL | `number` | JS float64 |
| TEXT | `string` | |
| BLOB | `Uint8Array` | Binary data |
```

§Five-canonical-passable-types map to §five-SQLite-types.
§All-five-are-passable (cycle 71's pass-style classifies each
as a primitive or Uint8Array — both pass cleanly across SES
realms and CapTP).

§Why-passable-matters: SQLite is a §host-function-API; values
that come back from SQLite must cross the §confinement-
boundary into §SES-locked-Compartments. §If-a-value-wasn't-
passable (e.g., a `Buffer` or a `Date`), it would either be
rejected at the boundary or silently lose fidelity.

§The-design-anchors-its-type-mapping on this constraint. §No-
sentinel-encodings-leak-to-the-user — the §FFI-tags
(`$bigint` / `$bytes`) live §inside-the-plumbing.

§Compare-to-cycle-189-marshal-justin's §eleven-qclass-cases
(passable-encoding for marshal). §Cycle-194-sqlite is the §dual:
ensure-host-values-are-already-passable-by-construction,
avoiding the need to encode them through marshal at all.
