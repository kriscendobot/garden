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
kind: index
section_count: 14
---

Sections:

- [Three-variant benchmark as bottleneck triangulation, fxHasPendingJobs as check-and-reset latch, and two-wrong-fixes considered before three-phase drain loop](endo-but-for-bots--llm-designs-daemon-rust-xs-performance--three-variant-benchmark-as-bottleneck-triangulation-and-fxHasPendingJobs-as-check-and-reset-latch--three-variant-benchmark-as-bot.md)
- [§The-three-variant-benchmark (the spine)](endo-but-for-bots--llm-designs-daemon-rust-xs-performance--three-variant-benchmark-as-bottleneck-triangulation-and-fxHasPendingJobs-as-check-and-reset-latch--the-three-variant-benchmark-the-spine.md)
- [§The-two-bug-fixes](endo-but-for-bots--llm-designs-daemon-rust-xs-performance--three-variant-benchmark-as-bottleneck-triangulation-and-fxHasPendingJobs-as-check-and-reset-latch--the-two-bug-fixes.md)
- [§fxHasPendingJobs-is-check-and-reset (the critical insight)](endo-but-for-bots--llm-designs-daemon-rust-xs-performance--three-variant-benchmark-as-bottleneck-triangulation-and-fxHasPendingJobs-as-check-and-reset-latch--fxhaspendingjobs-is-check-and-reset-the-critical-insight.md)
- [§Two-wrong-fixes-considered (the §illusion-of-an-option pattern)](endo-but-for-bots--llm-designs-daemon-rust-xs-performance--three-variant-benchmark-as-bottleneck-triangulation-and-fxHasPendingJobs-as-check-and-reset-latch--two-wrong-fixes-considered-the-illusion-of-an-option-pattern.md)
- [§The-correct-three-phase-drain-loop](endo-but-for-bots--llm-designs-daemon-rust-xs-performance--three-variant-benchmark-as-bottleneck-triangulation-and-fxHasPendingJobs-as-check-and-reset-latch--the-correct-three-phase-drain-loop.md)
- [§The-XS-block-scoping-bug-with-eval+try/catch](endo-but-for-bots--llm-designs-daemon-rust-xs-performance--three-variant-benchmark-as-bottleneck-triangulation-and-fxHasPendingJobs-as-check-and-reset-latch--the-xs-block-scoping-bug-with-eval-try-catch.md)
- [§The-benchmark-comparison-table](endo-but-for-bots--llm-designs-daemon-rust-xs-performance--three-variant-benchmark-as-bottleneck-triangulation-and-fxHasPendingJobs-as-check-and-reset-latch--the-benchmark-comparison-table.md)
- [§Four-remaining-optimization-opportunities (the §next-cycle of perf work)](endo-but-for-bots--llm-designs-daemon-rust-xs-performance--three-variant-benchmark-as-bottleneck-triangulation-and-fxHasPendingJobs-as-check-and-reset-latch--four-remaining-optimization-opportunities-the-next-cycle-of-perf-work.md)
- [§The-working-copy-inventory (the §uncommitted-change-map)](endo-but-for-bots--llm-designs-daemon-rust-xs-performance--three-variant-benchmark-as-bottleneck-triangulation-and-fxHasPendingJobs-as-check-and-reset-latch--the-working-copy-inventory-the-uncommitted-change-map.md)
- [§Status: Active (not Complete)](endo-but-for-bots--llm-designs-daemon-rust-xs-performance--three-variant-benchmark-as-bottleneck-triangulation-and-fxHasPendingJobs-as-check-and-reset-latch--status-active-not-complete.md)
- [§Cohesion notes](endo-but-for-bots--llm-designs-daemon-rust-xs-performance--three-variant-benchmark-as-bottleneck-triangulation-and-fxHasPendingJobs-as-check-and-reset-latch--cohesion-notes.md)
- [§Tier-1 borrowing](endo-but-for-bots--llm-designs-daemon-rust-xs-performance--three-variant-benchmark-as-bottleneck-triangulation-and-fxHasPendingJobs-as-check-and-reset-latch--tier-1-borrowing.md)
- [§Synthesis-target](endo-but-for-bots--llm-designs-daemon-rust-xs-performance--three-variant-benchmark-as-bottleneck-triangulation-and-fxHasPendingJobs-as-check-and-reset-latch--synthesis-target.md)
