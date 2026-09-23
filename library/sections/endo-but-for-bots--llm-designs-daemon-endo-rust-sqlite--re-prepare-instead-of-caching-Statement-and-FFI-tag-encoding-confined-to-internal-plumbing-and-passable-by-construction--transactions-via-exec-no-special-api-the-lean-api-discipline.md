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
title: §Transactions-via-exec-no-special-API (the §lean-API discipline)
parent: endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite--re-prepare-instead-of-caching-Statement-and-FFI-tag-encoding-confined-to-internal-plumbing-and-passable-by-construction
---

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
