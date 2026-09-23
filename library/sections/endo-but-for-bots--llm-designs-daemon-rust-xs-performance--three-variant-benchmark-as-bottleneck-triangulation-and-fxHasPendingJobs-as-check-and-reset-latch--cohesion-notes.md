---
source: designs/daemon-rust-xs-performance.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-rust-xs-performance.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - tooling
status_at_ingest: Active
genre: §endo-but-for-bots-design §performance-investigation
cycle: 188
lane: designs
status: current
title: §Cohesion notes
parent: endo-but-for-bots--llm-designs-daemon-rust-xs-performance--three-variant-benchmark-as-bottleneck-triangulation-and-fxHasPendingJobs-as-check-and-reset-latch
---

- §Three-variant-benchmark-as-bottleneck-triangulation: Node.js
  vs Rust+XS vs Rust+Node. §The-third-variant isolates
  supervisor from worker.
- §fxHasPendingJobs-is-check-and-reset (latch not counter)
  with §read-once-consume-once semantics.
- §Two-wrong-fixes-considered-and-rejected (sleep + blocking
  recv) before three-phase drain loop. §Sibling to cycle 186's
  §"illusion of an option" pattern.
- §The-blocking-recv-deadlock named explicitly with §reason
  ("waits for input that the worker can only produce after
  running more promise jobs").
- §Three-phase-drain-loop with §subtle-final-fxHasPendingJobs-
  check for §sendRawFrame-queued-jobs-without-producing-
  envelopes.
- §The-XS-block-scoping-bug + §CESU-8-encoding-bug + §off-by-
  one-frame-offset = §three-XS-engine-quirks-with-named-
  workarounds discovered during the work.
- §Benchmark-numbers-cited-from-three-angles (summary +
  before-table + after-table + speedup-column).
- §Four-remaining-optimizations named with §attribution-to-
  specific-mechanisms.
- §Working-copy-inventory section as §navigation-aid for
  in-progress work that spans three design documents.
- §Active-status as §living-investigation rather than §design-
  then-ship artifact.
