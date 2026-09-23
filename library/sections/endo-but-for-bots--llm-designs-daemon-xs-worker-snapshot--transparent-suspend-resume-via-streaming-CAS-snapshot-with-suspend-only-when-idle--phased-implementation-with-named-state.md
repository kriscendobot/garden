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
title: §Phased-implementation with named state
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot--transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle
---

| Phase | Content | State |
|-------|---------|-------|
| 1 | Rust snapshot FFI + Machine API | Complete (6 round-trip tests passing) |
| 2 | Supervisor suspend/resume | In Progress (most items done; 3 unit tests passing) |
| 3 | Auto-suspend, CAS GC, filesystem layout, cross-version compat | Future |

§Phase-1-resolved-an-unknown-callback-table-issue by
compiling XS from source (the prebuilt libxs.a came from a
different XS version).

§Cycle-141-daemon-cas-management's-§implementation-phases
have a sibling shape: phased-with-honest-state-reporting.

§Phase-2-remaining: integration test (full supervisor
round-trip), ephemeral GC root bookkeeping.

§Phase-3 names §four-future-enhancements without
committing to a timeline.
