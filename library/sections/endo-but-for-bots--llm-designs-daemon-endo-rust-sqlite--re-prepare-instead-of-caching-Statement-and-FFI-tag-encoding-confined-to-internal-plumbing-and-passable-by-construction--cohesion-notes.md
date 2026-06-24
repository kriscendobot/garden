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
title: §Cohesion notes
parent: endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite--re-prepare-instead-of-caching-Statement-and-FFI-tag-encoding-confined-to-internal-plumbing-and-passable-by-construction
---

- §Passable-by-construction-discipline (five SQLite types
  map to five canonical passable JS types).
- §INTEGER-always-bigint (Decision 1) eliminates the §opt-in-
  bigint-mode-flag that node:sqlite has.
- §BLOB-as-Uint8Array-not-sentinel (Decision 2) — §user-facing-
  clean-API with §FFI-tags-confined-to-internal-plumbing.
- §Re-prepare-instead-of-caching-Statement (Decision 4)
  works around the §self-referential-borrow of `&'conn
  Connection` via §store-the-recipe-not-the-instance.
- §Two-locks-never-held-simultaneously (STMT_MAP first, then
  DB_MAP) — §explicit-lock-ordering-discipline.
- §`$bigint` / `$bytes`-tags-in-JSON-FFI for §two-types-JSON-
  cannot-represent-natively.
- §Nine-host-functions covering the CRUD surface;
  §iterate/UDFs-deferred.
- §Three-pragma-bundle on open (WAL + foreign_keys=ON +
  5s busy_timeout).
- §Two-step-cleanup-on-close (retain-cascade on STMT_MAP +
  remove on DB_MAP).
- §Synchronous-JS-API matches XS host call convention.
- §Transactions-via-exec — §lean-API-no-special-methods.
- §rusqlite-bundled-feature for §self-contained-binary.
- §Nine-Design-Decisions in §canonical-format.
- §Seven-file-modification-list.
- §Six-implementation-phases all Complete.
- §Supersedes-field-in-metadata (the §explicit-supersedes-
  record-pattern that cycle 192 lacked).
