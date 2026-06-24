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
title: §Cleanup-on-database-close (the §retain-cascade pattern)
parent: endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite--re-prepare-instead-of-caching-Statement-and-FFI-tag-encoding-confined-to-internal-plumbing-and-passable-by-construction
---

```rust
fn host_sqlite_close(the: *mut XsMachine) {
    let handle = /* read arg 0 as u32 */;
    // Remove associated statements first
    let mut stmts = get_stmt_map();
    stmts.retain(|_, s| s.db_handle != handle);
    drop(stmts);
    // Then remove the connection
    let mut dbs = get_db_map();
    dbs.remove(&handle);
}
```

§Two-step-cleanup: §remove-associated-statements-first + §then-
remove-the-connection. §Order-matters: if the connection is
dropped first, the statements would still hold a reference
to a stale db_handle (no live connection, but the
`PreparedStmt` would still be in `STMT_MAP`).

§The-§retain-cascade pattern: `stmts.retain(|_, s| s.db_handle
!= handle)` keeps only entries that don't match. §Cycle-
174-gateway-package's §three-design-lifecycle-statuses-now-
distinguished is the §honest-status-discrimination analog at
a different scale.

§Design-Decision-7-named-explicitly: "Explicit `finalize()`
instead of GC. XS host handles require explicit cleanup.
`close()` also cleans up all associated statements."

§The-§explicit-cleanup discipline applies broadly to XS-host-
handles: cycle 188-perf names the discipline at fxAbort-level;
cycle 178-snapshot at callback-table-level; cycle 184-metering
at meterIndex-level. §Cycle-194-sqlite extends the discipline
to handle-map-managed resources.
