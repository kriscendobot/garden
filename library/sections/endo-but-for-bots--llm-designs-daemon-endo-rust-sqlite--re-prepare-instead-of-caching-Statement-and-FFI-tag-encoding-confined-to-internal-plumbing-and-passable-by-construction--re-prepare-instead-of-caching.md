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
title: §Re-prepare-instead-of-caching-Statement (the §workaround-for-self-referential-borrow)
parent: endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite--re-prepare-instead-of-caching-Statement-and-FFI-tag-encoding-confined-to-internal-plumbing-and-passable-by-construction
---

```rust
struct PreparedStmt {
    db_handle: u32,
    sql: String,
}
```

```
`rusqlite::Statement` borrows from `Connection`
(`&'conn Connection`), so storing both in separate static
maps creates a self-referential borrow that Rust rejects.

Solution: `STMT_MAP` stores the SQL text and owning db handle,
not a live `Statement`.  Each `run` / `get` / `all` call locks
`DB_MAP`, gets the `Connection`, calls `conn.prepare(&sql)`,
executes, and drops the `Statement`.  SQLite internally caches
prepared-statement bytecode, so the re-prepare cost is
negligible for the daemon's metadata workload.
```

§The-§self-referential-borrow-problem named-explicitly. §The-
§solution: store-the-recipe-not-the-instance. §`PreparedStmt`
stores `(db_handle, sql)` — the §source-of-truth for re-
creating a `Statement` on demand.

§Why-this-works: §SQLite-internally-caches-prepared-statement-
bytecode. §The-re-prepare-cost-is-negligible because the bytecode
is hot in SQLite's internal cache.

§The-§lock-ordering discipline named:

```
Lock ordering: always lock `STMT_MAP` first (to extract
`db_handle` and `sql`), drop that lock, then lock `DB_MAP`.
Never hold both locks simultaneously.
```

§Two-locks-never-held-simultaneously prevents deadlock. §The-
discipline-is-named-in-prose (not just in comment) because
it's load-bearing for correctness.

§Compare-to-cycle-184-metering's §three-phase-drain-loop. §Both-
are-§explicit-lock-ordering-or-phase-ordering discipline
patterns. §Cycle-184-orders-phases-of-message-processing;
cycle 194-orders-lock-acquisition.

§Compare-to-cycle-178-snapshot's §append-only-callback-table
(§stable-indices-across-suspend-resume). §Both-are-§stable-
handle-identifier-discipline. §Cycle-178-uses-append-only;
cycle-194-uses-the-(db_handle, sql)-tuple-as-the-stable-
identity.

§Tier-1-borrowing: §store-the-recipe-not-the-instance for any
§self-referential-borrow-blocker. §If-the-instance-can-be-
recreated-cheaply-from-its-recipe, defer instantiation.
