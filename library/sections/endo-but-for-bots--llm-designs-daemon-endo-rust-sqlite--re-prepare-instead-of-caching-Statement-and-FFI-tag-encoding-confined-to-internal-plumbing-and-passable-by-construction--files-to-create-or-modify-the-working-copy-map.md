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
title: §Files-to-create-or-modify (the §working-copy-map)
parent: endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite--re-prepare-instead-of-caching-Statement-and-FFI-tag-encoding-confined-to-internal-plumbing-and-passable-by-construction
---

| File | Change |
|---|---|
| `rust/endo/xsnap/src/powers/sqlite.rs` | New. 9 host functions, JSON encoding |
| `rust/endo/xsnap/src/powers/mod.rs` | Add `pub mod sqlite;` |
| `rust/endo/xsnap/src/lib.rs` | Register sqlite power |
| `rust/endo/xsnap/Cargo.toml` | Add `rusqlite` with `bundled` |
| `rust/endo/xsnap/src/host_aliases.js` | Add 9 sqlite aliases |
| `packages/daemon/src/bus-daemon-rust-xs-powers.js` | Add `makeXsSqlitePowers()` |
| `packages/daemon/src/types.d.ts` | Add types |

§Seven-files-modified or §created (one new + six modified).
§Compare-to-cycle-188-perf's §working-copy-inventory mapping
eight uncommitted change clusters to three design docs. §Both-
are-§navigation-aid for review.
