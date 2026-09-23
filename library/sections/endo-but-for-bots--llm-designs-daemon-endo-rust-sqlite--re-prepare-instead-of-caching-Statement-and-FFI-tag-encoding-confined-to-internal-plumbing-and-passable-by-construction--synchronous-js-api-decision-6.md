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
title: §Synchronous-JS-API (Decision 6)
parent: endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite--re-prepare-instead-of-caching-Statement-and-FFI-tag-encoding-confined-to-internal-plumbing-and-passable-by-construction
---

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
