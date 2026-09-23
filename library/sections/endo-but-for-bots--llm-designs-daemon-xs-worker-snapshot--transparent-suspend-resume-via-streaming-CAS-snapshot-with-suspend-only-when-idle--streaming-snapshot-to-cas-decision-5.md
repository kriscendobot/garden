---
source: designs/daemon-xs-worker-snapshot.md
source_repo: endojs/endo-but-for-bots
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-xs-worker-snapshot.md
source_path: designs/daemon-xs-worker-snapshot.md
source_branch: llm
section_kind: design
ingested: 2026-06-04
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - persistence
  - patterns
genre: §endo-but-for-bots-design
cycle: 178
lane: designs
status: current
title: §Streaming-snapshot-to-CAS (Decision 5)
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot--transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle
---

> *The full snapshot is never buffered in memory.*

§Stream-don't-buffer. §Cycle-141-daemon-cas-management
provides the CAS; §cycle-176-daemon-endor-architecture
also names this discipline.

§Suspend-streaming:
1. Worker streams XS snapshot chunks via `fxWriteSnapshot`
   callback to a temp file in CAS directory.
2. §SHA-256-computed-on-the-fly.
3. Atomic rename to `{cas_dir}/{sha256_hex}`.
4. Worker sends `"suspended"` with hex digest only —
   §only-the-hash-transits-the-envelope-bus.

§Resume-streaming:
1. Supervisor sends `"restore"` init with CAS file path.
2. Worker calls `Machine::from_snapshot_file()`, §streaming-
   from-disk.
3. Full snapshot never resides in memory.

§Memory-bounded-suspend-and-resume regardless of worker
heap size.

§Atomic-rename-after-write is the §write-then-publish
discipline (cycle 141 sibling at content-store layer).
