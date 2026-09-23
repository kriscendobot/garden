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
title: §Nine-Design-Decisions (the §canonical-format)
parent: endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite--re-prepare-instead-of-caching-Statement-and-FFI-tag-encoding-confined-to-internal-plumbing-and-passable-by-construction
---

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
