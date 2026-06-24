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
title: §The-§nine-host-functions (the API surface)
parent: endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite--re-prepare-instead-of-caching-Statement-and-FFI-tag-encoding-confined-to-internal-plumbing-and-passable-by-construction
---

| Rust function | Registration name | argc | JS signature |
|---|---|---|---|
| `host_sqlite_open` | `sqliteOpen` | 1 | `sqliteOpen(path)` |
| `host_sqlite_close` | `sqliteClose` | 1 | `sqliteClose(dbH)` |
| `host_sqlite_exec` | `sqliteExec` | 2 | `sqliteExec(dbH, sql)` |
| `host_sqlite_prepare` | `sqlitePrepare` | 2 | `sqlitePrepare(dbH, sql)` |
| `host_sqlite_stmt_run` | `sqliteStmtRun` | 2 | `sqliteStmtRun(stmtH, paramsJson)` |
| `host_sqlite_stmt_get` | `sqliteStmtGet` | 2 | `sqliteStmtGet(stmtH, paramsJson)` |
| `host_sqlite_stmt_all` | `sqliteStmtAll` | 2 | `sqliteStmtAll(stmtH, paramsJson)` |
| `host_sqlite_stmt_columns` | `sqliteStmtColumns` | 1 | `sqliteStmtColumns(stmtH)` |
| `host_sqlite_stmt_finalize` | `sqliteStmtFinalize` | 1 | `sqliteStmtFinalize(stmtH)` |

§Nine-functions covering §the-CRUD-surface. §Design-Decision-
9-named-explicitly: "9 functions, not more. Covers the CRUD
surface needed for daemon storage. `iterate` and UDFs are
deferred until needed."

§Compare-to-cycle-184-metering's §five-control-verbs (meter-
query/reset/set-quota/set-rate/refill) + §meter-config + §meter-
report = seven-verbs. §Both-are-§named-handle-based-API patterns.

§Compare-to-cycle-188-perf's §three-class-progressive-syscall-
migration (fs first, net second, crypto third). §This-design's
§nine-functions match the §fs / crypto pattern at a different
domain (SQLite).

§The-§host-aliases.js-line-pattern (`hostSqliteOpen: 'sqliteOpen'`)
appears nine times — §one-line-per-host-function.

§The-§define-function-registration follows cycle 176-endor's
§host-function-registration-as-explicit-list discipline.
