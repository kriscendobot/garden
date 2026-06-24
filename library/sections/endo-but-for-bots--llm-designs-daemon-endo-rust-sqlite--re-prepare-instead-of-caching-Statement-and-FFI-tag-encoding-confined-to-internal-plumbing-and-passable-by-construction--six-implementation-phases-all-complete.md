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
title: §Six-implementation-phases (all Complete)
parent: endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite--re-prepare-instead-of-caching-Statement-and-FFI-tag-encoding-confined-to-internal-plumbing-and-passable-by-construction
---

```
1. Add rusqlite to Cargo.toml, verify compilation with bundled feature. (done)
2. Create powers/sqlite.rs with DB_MAP, open/close/exec. Smoke-test. (done)
3. Add prepare and statement functions. Implement $bigint/$bytes encoding. (done)
4. Add host aliases to host_aliases.js. (done)
5. Build JS makeXsSqlitePowers() wrapper. Add types. (done)
6. Integration test: open, create, insert bigint+Uint8Array, select, verify round-trip. (done)
```

§Six-phases-all-Complete with §parenthetical-(done)-mark on
each. §Phase-1-validates-the-toolchain-before-writing-source
discipline (cycle 188's §phase-1-scaffold sibling).

§Phase-2-smoke-test-pattern: open + create-table + close.
§Minimum-viable-roundtrip before adding more host functions.

§Phase-6-integration-test exercises the §full-round-trip with
the §two-tricky-types (bigint + Uint8Array). §A-single-test
that covers the §key-correctness-property of §passable-by-
construction.
