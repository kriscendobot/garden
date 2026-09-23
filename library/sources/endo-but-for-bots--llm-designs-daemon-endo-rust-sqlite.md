---
title: 'endo-but-for-bots designs/daemon-endo-rust-sqlite.md — SQLite host methods for Endo Rust (XS)'
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-endo-rust-sqlite.md
source_paths:
  - designs/daemon-endo-rust-sqlite.md
authors:
  - Kris Kowal (prompted)
created: 2026-04-14
updated: 2026-04-16
status_at_ingest: Complete
ingested: 2026-06-05
ingested_by: scholar
topics:
  - daemon
  - persistence
sections:
  - endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite--re-prepare-instead-of-caching-Statement-and-FFI-tag-encoding-confined-to-internal-plumbing-and-passable-by-construction.md
genre: §endo-but-for-bots-design §host-function-package-for-XS-rust
cycle: 194
lane: designs
---

# SQLite Host Methods for Endo Rust (XS) — design

## §Abstract

634-line **Complete** design (Created 2026-04-14, Updated
2026-04-16; all six phases implemented; 14 unit tests
shipped). §SQLite-host-methods for XS workers running inside
the Rust endor supervisor, presenting an API aligned with
`node:sqlite`'s `DatabaseSync` / `StatementSync`.

§Supersedes-`daemon-endor-sqlite.md` (named in metadata —
§explicit-supersedes-record-pattern that cycle 192-engo
lacked).

§The-key-mechanisms:

1. §Passable-by-construction discipline (five SQLite types
   map to five canonical passable JS types: null / bigint /
   number / string / Uint8Array).
2. §INTEGER-always-bigint (Decision 1) — eliminates
   `setReadBigInts` mode flag; avoids silent precision loss
   for values > 2^53.
3. §BLOB-as-Uint8Array-not-sentinel (Decision 2) — user-
   facing clean API; FFI `$bytes`/`$bigint` tags confined to
   internal plumbing.
4. §Re-prepare-instead-of-caching-Statement (Decision 4) —
   workaround for `&'conn Connection` self-referential borrow;
   STMT_MAP stores `(db_handle, sql)` recipe, not live
   Statement. SQLite's internal bytecode cache makes re-
   prepare cheap.
5. §Two-locks-never-held-simultaneously discipline (STMT_MAP
   first to extract recipe, then DB_MAP).

§Nine-host-functions covering the CRUD surface (open / close /
exec / prepare / stmtRun / stmtGet / stmtAll / stmtColumns /
stmtFinalize). §`iterate()`-and-UDFs deferred per Design
Decision 9.

§Three-pragma-bundle on open (WAL mode + foreign_keys=ON +
5s busy_timeout) for §daemon-concurrent-read-performance
during formula-eval + GC scan.

§Two-step-cleanup-on-close (retain-cascade on STMT_MAP +
remove on DB_MAP).

§Synchronous-JS-API matches XS host call convention.

## §Files and identifiers

| File | Lines | Role |
|------|-------|------|
| `designs/daemon-endo-rust-sqlite.md` | 634 | This design |
| `rust/endo/xsnap/src/powers/sqlite.rs` | — | 9 host functions, DB_MAP/STMT_MAP |
| `rust/endo/xsnap/src/powers/mod.rs` | — | `pub mod sqlite;` |
| `rust/endo/xsnap/src/lib.rs` | — | `powers::sqlite::register()` |
| `rust/endo/xsnap/Cargo.toml` | — | `rusqlite = { version = "0.31", features = ["bundled"] }` |
| `rust/endo/xsnap/src/host_aliases.js` | — | 9 sqlite alias entries |
| `packages/daemon/src/bus-daemon-rust-xs-powers.js` | — | `makeXsSqlitePowers()` factory |
| `packages/daemon/src/types.d.ts` | — | `SqlitePowers`, `DatabaseSync`, `StatementSync` types |

## §Provenance and dependencies

- §Supersedes-`daemon-endor-sqlite.md` (the prior design,
  named in metadata's Supersedes field).
- §Built-on cycle 176-endor-architecture (the Rust supervisor
  that hosts these powers).
- §Built-on cycle 178-snapshot's §append-only-callback-table
  (sibling §stable-handle-identifier-discipline).
- §rusqlite-0.31-with-bundled-feature (no system library
  dependencies).
- §node:sqlite-API as the §reference-shape for `DatabaseSync` /
  `StatementSync`.

## §Related sources in the library

- §Cycle 176 (`endo-but-for-bots--llm-designs-daemon-endor-
  architecture.md`) — parent Rust supervisor architecture.
  §Sqlite-power-registration follows the cycle-176 §host-
  function-registration-as-explicit-list pattern.
- §Cycle 178 (`endo-but-for-bots--llm-designs-daemon-xs-
  worker-snapshot.md`) — §sibling §explicit-cleanup-of-XS-
  host-handles discipline (callback-table).
- §Cycle 184 (`endo-but-for-bots--llm-designs-daemon-xs-
  worker-metering.md`) — §sibling §sync-by-XS-machinery
  discipline; §three-phase-drain-loop is the §explicit-phase-
  ordering analog of cycle 194's §explicit-lock-ordering.
- §Cycle 188 (`endo-but-for-bots--llm-designs-daemon-rust-xs-
  performance.md`) — §working-copy-inventory sibling pattern
  (cycle 194's Status section enumerates shipped artifacts).
- §Cycle 189 (`endo--packages-marshal-src-marshal-justin-
  and-marshal-stringify-js.md`) — §eleven-qclass-cases sibling
  (cycle 194 needs only two tags `$bigint`/`$bytes`).
- §Cycle 190 (`endo-but-for-bots--llm-designs-endo-posix-
  sandbox.md`) — §Supersedes-record-pattern via prose-section.
  §Cycle-194 uses §metadata-field-only.
- §Cycle 192 (`endo-but-for-bots--llm-designs-daemon-engo-
  supervisor.md`) — §the-lesson-learned about explicit
  Supersedes records that cycle 194 applies via metadata
  field.
- §Cycle 193 (`endo--packages-import-bundle-src-compartment-
  wrapper-js.md`) — §sibling §honest-deferred-fix-in-source
  (cycle 193's SECURITY-NOTE; cycle 194's deferred features
  in Design Decision 9).
- §Cycle 169 (`endo--packages-captp-src-atomics-js.md`) —
  §SharedArrayBuffer-low-level-FFI vs cycle 194's §JSON-tag-
  FFI tradeoff (Design Decision 3 names this).

## §Comment fragments worth preserving

```
The key constraint is that all values returned by the SQLite
bindings must be passable — expressible by Endo's
marshalling.
```

§The-§passable-by-construction-discipline named-explicitly as
the design's anchor.

```
INTEGER is always bigint.  Unlike `node:sqlite`'s opt-in
`setReadBigInts`, the XS bindings always return `bigint` for
INTEGER columns.  This avoids silent precision loss for values
beyond 2^53 and removes the need for a per-statement mode
flag.
```

§Strictest-default-removes-a-mode-flag discipline. §The-
§deliberate-asymmetry-with-node:sqlite acknowledged.

```
`rusqlite::Statement` borrows from `Connection`
(`&'conn Connection`), so storing both in separate static
maps creates a self-referential borrow that Rust rejects.

Solution: `STMT_MAP` stores the SQL text and owning db handle,
not a live `Statement`.
```

§Self-referential-borrow-problem named-explicitly. §Store-the-
recipe-not-the-instance solution.

```
Lock ordering: always lock `STMT_MAP` first (to extract
`db_handle` and `sql`), drop that lock, then lock `DB_MAP`.
Never hold both locks simultaneously.
```

§Explicit-lock-ordering-discipline. §The-deadlock-prevention
named in prose.

```
The `bundled` feature compiles SQLite from C source,
eliminating system library dependencies.  Adds ~2 MB to the
binary and ~30 s to the first build (cached thereafter).
```

§Honest-cost-disclosure for the bundled-feature.

```
9 functions, not more.  Covers the CRUD surface needed for
daemon storage.  `iterate` and UDFs are deferred until needed.
```

§Lean-API-discipline. §Decision-9-named-explicitly.
