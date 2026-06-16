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
title: §INTEGER-always-bigint (Decision 1)
parent: endo-but-for-bots--llm-designs-daemon-endo-rust-sqlite--re-prepare-instead-of-caching-Statement-and-FFI-tag-encoding-confined-to-internal-plumbing-and-passable-by-construction
---

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
