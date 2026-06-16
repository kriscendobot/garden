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
title: §Database-open-defaults (the §three-pragma-bundle)
parent: endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite--re-prepare-instead-of-caching-Statement-and-FFI-tag-encoding-confined-to-internal-plumbing-and-passable-by-construction
---

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
