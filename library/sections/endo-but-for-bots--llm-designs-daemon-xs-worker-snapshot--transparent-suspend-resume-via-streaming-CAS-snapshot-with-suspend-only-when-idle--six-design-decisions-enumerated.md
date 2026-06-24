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
title: §Six-Design-Decisions enumerated
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot--transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle
---

1. Snapshot-as-internal-implementation-detail.
2. Suspend-only-when-idle.
3. Transparent-resume-on-message.
4. CAS-storage-with-ephemeral-GC-roots.
5. Streaming-snapshot-to-CAS-not-in-memory.
6. Callback-table-is-append-only.

§Each-decision-named. §Cycle-170's-seven-Open-Questions /
cycle-176's-no-explicit-Open-Questions / this design's
§revised-scope-section show three §design-honesty patterns.
