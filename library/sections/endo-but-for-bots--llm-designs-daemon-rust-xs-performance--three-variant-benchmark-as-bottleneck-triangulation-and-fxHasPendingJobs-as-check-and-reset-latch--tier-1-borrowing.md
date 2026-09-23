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
title: §Tier-1 borrowing
parent: endo-but-for-bots--llm-designs-daemon-rust-xs-performance--three-variant-benchmark-as-bottleneck-triangulation-and-fxHasPendingJobs-as-check-and-reset-latch
---

- §three-variant-benchmark-as-bottleneck-triangulation (A vs
  B vs C lets you isolate which boundary causes the cost)
- §check-and-reset-latch-not-counter (read-once-consume-once
  flag semantics)
- §two-wrong-fixes-considered-and-rejected (the §illusion-of-
  an-option pattern applied to performance fixes; name the
  deadlock + the dead-time)
- §three-phase-drain-loop (drain-jobs → drain-envelopes →
  check-for-new-work → loop or break)
- §subtle-final-check-for-implicit-state (the second
  fxHasPendingJobs check catches jobs queued without envelopes)
- §benchmark-numbers-cited-from-three-angles
- §working-copy-inventory section as §navigation-aid
- §Active-status as §living-investigation
- §the-§XS-engine-quirks-taxonomy (block-scoping + CESU-8 +
  frame offsets join cycle 176's CESU-8 + cycle 178's callback
  table)
- §designs-as-archives-of-in-progress-work (not just shipped)
