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
title: §Tier-1 vocabulary borrowing candidates
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-snapshot--transparent-suspend-resume-via-streaming-CAS-snapshot-with-suspend-only-when-idle
---

§Snapshot-as-internal-implementation-detail (transparency
of state to the manager).

§Suspend-only-when-idle (avoid the hard reconnection
problem by requiring quiescence).

§Streaming-snapshot-to-CAS-not-in-memory (memory-bounded
regardless of heap size).

§CAS-storage-with-ephemeral-GC-roots (durable storage +
transient pinning).

§Append-only-callback-table (stable indices across
suspend/resume).

§Two-init-paths-one-entry-point (init vs restore as a
mode flag).

§Big-data-through-filesystem-small-coordination-through-
envelopes.

§Revised-scope-as-honest-design-evolution-record.

§Tier-2: §atomic-rename-after-write, §SHA-256-on-the-fly
computation.
