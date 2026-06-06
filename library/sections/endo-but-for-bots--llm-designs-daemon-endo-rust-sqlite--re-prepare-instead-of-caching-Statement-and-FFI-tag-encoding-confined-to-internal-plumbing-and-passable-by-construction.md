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
---

# Re-prepare instead of caching Statement (avoid self-referential borrow), FFI tag encoding confined to internal plumbing, INTEGER-always-bigint, and passable-by-construction discipline

> §Designs-lane after cycle 193's chat-lane. §The-twenty-
> eighth-consecutive designs/chat alternation cycle (166-
> 194). §Status: **Complete** — all six phases implemented;
> 14 unit tests. §Sibling-to-cycle-188-perf's §working-copy-
> inventory pattern (this design's Status section enumerates
> shipped artifacts).

`daemon-endo-rust-sqlite.md` (634 lines, Created 2026-04-14,
Updated 2026-04-16, **Complete**) designs SQLite host
functions for XS workers running inside the Rust endor
supervisor. §Supersedes-an-earlier-`daemon-endor-sqlite.md`
(named in the metadata's §Supersedes-field — the §canonical-
supersedes-record-pattern that cycle 192 lacked).

§The-single-most-structurally-interesting-move is §re-prepare-
instead-of-caching-Statement (the §workaround-for-self-
referential-borrow) + §`$bigint`/`$bytes`-tags-confined-to-
FFI-layer + §INTEGER-always-bigint + §BLOB-as-Uint8Array-not-
sentinel + §passable-by-construction-discipline. §Five-named-
moves in 634 lines.

## §The-§passable-by-construction-discipline (the design anchor)

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

## §INTEGER-always-bigint (Decision 1)

```
- **INTEGER is always bigint.**
  Unlike `node:sqlite`'s opt-in `setReadBigInts`, the XS
  bindings always return `bigint` for INTEGER columns.
  This avoids silent precision loss for values beyond 2^53
  and removes the need for a per-statement mode flag.
```

§The-§deliberate-asymmetry-with-node:sqlite. §Node-defaults-to-
number-and-makes-bigint-opt-in (`setReadBigInts(true)`); §the-
XS-bindings-default-to-bigint-with-no-opt-out.

§The-rationale-named-explicitly: §silent-precision-loss for
values beyond 2^53. §SQLite-INTEGER-is-64-bit; §JS-number-is-
float64-with-53-bit-mantissa.

§Compare-to-cycle-181-base64's §nativeFromBase64Options-pinned-
to-strictest-semantics. §Both-are-§strictest-default-removes-
a-mode-flag patterns. §Cycle-181-eliminates-`lastChunkHandling:'loose'`;
§cycle-194-eliminates-`setReadBigInts`-mode.

§The-§lastInsertRowid: bigint property carries this discipline
into the §run-result shape. §"`lastInsertRowid` can exceed
2^53 for large tables" — Design Decision 8.

§Tier-1-borrowing: §strictest-default-removes-a-mode-flag
discipline. §Where-the-strict-version-is-correct-for-all-
inputs, eliminate the mode-flag entirely.

## §BLOB-as-Uint8Array-not-sentinel (Decision 2)

```
- **BLOB is Uint8Array, not a JSON sentinel.**
  There is no `$blob` encoding, no smallcaps, no fancy JSON
  encoding of any kind in the user-facing API.
  The JS wrapper presents clean `Uint8Array` values to
  callers.
```

§The-§user-facing-clean-API discipline. §The-§FFI-tags-
(`$bigint`/`$bytes`)-live-inside-the-plumbing; §the-JS-
wrapper-decodes-them before returning to callers.

§Why: callers shouldn't have to know about the FFI's JSON-
transport limitations. §A-`Uint8Array`-in-the-database round-
trips to a `Uint8Array` in the JS code — no `{$bytes: "base64"}`
ever appears in user code.

§Compare-to-cycle-189-marshal-justin's §`__proto__`-bracket-
escape (preserve JSON vs JS prototype-set semantics). §Both-
are-§internal-representation-distinct-from-user-API patterns.

§Compare-to-cycle-178-snapshot's §snapshot-as-internal-
implementation-detail-not-user-visible-formula. §Both-are-
§hide-the-plumbing-from-the-user-API discipline.

§Tier-1-borrowing: §user-facing-clean-API-with-FFI-tags-
confined-to-internal-plumbing. §The-encoding-tax is paid by
the wrapper, not the caller.

## §Re-prepare-instead-of-caching-Statement (the §workaround-for-self-referential-borrow)

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

## §FFI-tag-encoding-confined-to-internal-plumbing

§Parameters-JS-to-Rust:

```
| JS type | FFI JSON encoding | Rust conversion |
|---------|-------------------|-----------------|
| `null` | `null` | NULL |
| `boolean` | `true` / `false` | INTEGER (1 / 0) |
| `number` | number | REAL |
| `string` | string | TEXT |
| `bigint` | `{"$bigint": "123"}` | INTEGER |
| `Uint8Array` | `{"$bytes": "<base64>"}` | BLOB |
```

§Six-encoding-rows: §four-pass-natively (null/boolean/number/
string) + §two-tagged ({"$bigint": ...} + {"$bytes": ...}).

§The-`$bigint` tag is needed because §JSON-cannot-represent-
bigint-natively. §The-`$bytes` tag is needed because §JSON-
cannot-represent-Uint8Array-natively.

§The-`encodeValue` / `decodeValue` / `decodeRow` JS helpers
handle the encoding at the §FFI-boundary; the rest of the JS
wrapper sees clean values.

§Compare-to-cycle-191-zip's §u-helper for §canonical-zip-
signatures. §Both-are-§internal-encoding-helpers that compress
boilerplate.

§Compare-to-cycle-189-marshal-justin's §eleven-qclass-cases
(undefined / NaN / Infinity / -Infinity / bigint / @@asyncIterator
/ symbol / tagged / slot / hilbert / error). §Cycle-194-sqlite-
needs-only-two-tags because the input domain is constrained
to SQLite's five-type-system.

§Design-Decision-3-named-explicitly: "Internal FFI uses
`$bigint` / `$bytes` tags in JSON. JSON cannot represent
bigint or binary natively. The tags are confined to the FFI
layer — the JS wrapper converts them to/from native types.
This is simpler than constructing XS typed arrays from Rust
via low-level slot manipulation."

§The-§simpler-than-low-level-slot-manipulation reason names
the alternative-that-was-rejected. §A-rust-side-could-have-
constructed-XS-Uint8Arrays-directly via FFI slot manipulation
(cycle 169 atomics.js has similar low-level work); §the-
design-chose-JSON-tags-as-the-simpler-tradeoff.

## §The-§nine-host-functions (the API surface)

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

## §Database-open-defaults (the §three-pragma-bundle)

```
`sqliteOpen(path)` applies these pragmas automatically:

- `PRAGMA journal_mode=WAL;` — concurrent read performance
- `PRAGMA foreign_keys=ON;`
- `busy_timeout(5000)` — 5 s busy wait

Path `":memory:"` opens an in-memory database.
```

§Three-pragmas-bundled-with-open. §Design-Decision-5-named-
explicitly: "WAL mode by default. Critical for concurrent
read performance when the daemon evaluates formulas while
GC scans the graph."

§Why-WAL: §the-daemon-has-concurrent-readers (formula eval +
GC scan). §Default-rollback-journal-mode blocks readers
during writes; WAL allows concurrent reads.

§Why-foreign_keys-on: §SQLite-defaults-to-off (legacy
compatibility); §every-modern-schema-design wants foreign-
key-checks. §Opt-in-by-default is wrong; flip to §opt-out-by-
default.

§Why-5s-busy-timeout: §reasonable-default for handling brief
lock contention; §callers-can-override per-connection.

§Compare-to-cycle-181-base64's §nativeFromBase64Options-pinned
{lastChunkHandling:'strict', alphabet:'base64'}. §Both-are-
§pin-the-strict-defaults-at-the-construction-boundary patterns.

§The-§memory-special-case (`:memory:` path) follows §sqlite's-
own-API-convention. §The-design-doesn't-overload-this; it
inherits-the-sqlite-discipline.

## §Cleanup-on-database-close (the §retain-cascade pattern)

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

## §Synchronous-JS-API (Decision 6)

```
- **Synchronous JS API.**
  Matches `node:sqlite`'s `DatabaseSync` and the XS host
  function calling convention (all host calls are
  synchronous).
```

§The-§sync-by-construction discipline. §XS-host-calls-are-
inherently-synchronous; §making-the-JS-API-async would add a
microtask boundary with no benefit.

§Compare-to-cycle-184-metering's §custom-fxAbort-via-longjmp
(synchronous abort within the worker thread). §Both-are-§sync-
by-XS-machinery-discipline patterns.

§Compare-to-cycle-169-atomics.js' §Atomics.wait/notify-for-
blocking-RPC. §Cycle-169-is the §synchronous-RPC-across-thread
mechanism; §cycle-194-sqlite-is-the-§synchronous-RPC-within-
thread mechanism.

§Tier-1-borrowing: §sync-by-construction-when-the-substrate-
is-sync. §Don't-paint-on-async-where-the-host-machinery-is-
synchronous.

## §Transactions-via-exec-no-special-API (the §lean-API discipline)

```js
db.exec('BEGIN');
try {
  // ... operations ...
  db.exec('COMMIT');
} catch (e) {
  db.exec('ROLLBACK');
  throw e;
}

This matches `node:sqlite` which also controls transactions
via `exec`.
```

§No-`beginTransaction()`/`commit()`/`rollback()`-methods.
§Transactions-are-just-SQL-statements; §exec-is-the-canonical-
SQL-runner.

§The-§lean-API discipline: §don't-add-API-when-existing-API-
suffices. §Compare-to-cycle-180-hex-package's §five-known-gaps
naming things-not-yet-added; cycle-194-sqlite is the §minimal-
API-completed-state.

§Compare-to-cycle-184-metering's §burst-ceiling-prevents-budget-
hoarding — both-are-§don't-over-specify-the-API patterns.

## §Cargo-dependency-with-bundled-feature

```
rusqlite = { version = "0.31", features = ["bundled"] }
```

```
The `bundled` feature compiles SQLite from C source,
eliminating system library dependencies. Adds ~2 MB to the
binary and ~30 s to the first build (cached thereafter).
```

§The-§bundled-feature discipline: §no-system-library-
dependencies; §binary-is-self-contained.

§The-§cost-named-explicitly: §2-MB-binary-size + §30s-first-
build. §Honest-cost-disclosure.

§Compare-to-cycle-176-endor-architecture's §five-embedded-JS-
bundles-via-include_str! pattern. §Both-are-§self-contained-
binary-via-embedded-source patterns.

§The-§"bundled" feature in `rusqlite` is a §Cargo-feature-flag;
the design names which-features-to-enable explicitly. §Compare-
to-cycle-186-break-dev-deps' §package-namespaced-conditions
(`test-endo-foo` not bare `test`).

## §Nine-Design-Decisions (the §canonical-format)

| # | Decision | Reason |
|---|----------|--------|
| 1 | INTEGER always returns bigint | Avoids precision loss; eliminates mode flag |
| 2 | BLOB returns Uint8Array, not JSON sentinel | User-facing clean API |
| 3 | Internal FFI uses `$bigint`/`$bytes` tags in JSON | Simpler than low-level slot manipulation |
| 4 | Re-prepare instead of caching `Statement` | Avoids self-referential borrow; bytecode cache makes it cheap |
| 5 | WAL mode by default | Concurrent read performance for daemon + GC |
| 6 | Synchronous JS API | XS host calls are inherently synchronous |
| 7 | Explicit `finalize()` instead of GC | XS host handles need explicit cleanup |
| 8 | `run()` returns `{changes: bigint, lastInsertRowid: bigint}` | Consistency with "INTEGER always bigint" |
| 9 | 9 functions, not more | Covers CRUD; iterate/UDFs deferred |

§Nine-Design-Decisions matches cycle 174-gateway-package's §eight
+ cycle 180-hex-package's §eight + cycle 184-metering's §seven.
§The-§canonical-Design-Decisions-format honored.

§Compare-to-cycle-178-snapshot's §six-Design-Decisions and
cycle 192-engo's §seven-design-decisions (implied across the
five-phases). §The-design-decision-count varies; §the-format
is stable.

## §Files-to-create-or-modify (the §working-copy-map)

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

## §Six-implementation-phases (all Complete)

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

## §Supersedes-record-pattern (the §explicit-supersedes that cycle 192 lacked)

```
| **Supersedes** | designs/daemon-endor-sqlite.md |
```

§The-§Supersedes-field-in-metadata-table names the prior
design explicitly. §The-§canonical-supersedes-record-pattern
that cycle 192-engo lacked (cycle 192/176 had an §implicit-
supersedes).

§Compare-to-cycle-190-endo-posix-sandbox's §Relationship-to-
daemon-os-sandbox-plugin section with §three-improvements-
named. §Cycle-194's-Supersedes is §metadata-field-only-without-
relationship-prose, but the §metadata-field-itself is the
§explicit-record.

§Tier-1-borrowing: §Supersedes-field-in-design-metadata for
§explicit-prior-relationship-tracking. §Either-§metadata-field
or §relationship-prose-section satisfies the discipline.

## §Cohesion notes

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

## §Tier-1 borrowing

- §passable-by-construction-discipline (host-function-API
  returns values that are passable across SES boundaries
  without further encoding)
- §strictest-default-removes-a-mode-flag (where the strict
  version is correct for all inputs, eliminate the mode-
  flag)
- §user-facing-clean-API-with-FFI-tags-confined-to-internal-
  plumbing
- §store-the-recipe-not-the-instance (workaround for self-
  referential borrow; defer instantiation when cheap)
- §explicit-lock-ordering-discipline (named in prose, not
  just in comment)
- §three-pragma-bundle for sqlite-open (WAL + foreign_keys=ON
  + busy_timeout)
- §two-step-cleanup-with-retain-cascade
- §sync-by-construction-when-the-substrate-is-sync
- §lean-API-don't-add-API-when-existing-API-suffices
- §bundled-Cargo-feature for self-contained-binary
- §Supersedes-field-in-metadata for §explicit-prior-
  relationship-tracking (the cycle-192 lesson-learned
  applied)
- §phase-1-scaffold + §phase-2-smoke-test + §phase-N-
  integration-test rhythm

## §Synthesis-target

The §slot-machine-library's persistent-storage-layer (if any)
can §borrow-the-five-type-mapping directly for any §SQL-or-KV-
store-wrapper. §The-§passable-by-construction discipline is
the §canonical-design-constraint for any §host-function-API.

§The-§store-the-recipe-not-the-instance pattern is borrowable
for any §Rust-FFI-or-other-language-binding where §lifetime-
constraints-block-direct-caching. §Defer-instantiation; let
the underlying library cache the heavy work.

§The-§Supersedes-field-in-metadata pattern (cycle 192's §lesson-
learned) is borrowable for §explicit-prior-relationship-
tracking in any design that replaces a prior. §The-metadata-
field-alone-suffices; a §relationship-prose-section is
optional but valuable for §three-named-improvements detail.
