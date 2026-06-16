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
title: §The-working-copy-inventory (the §uncommitted-change-map)
parent: endo-but-for-bots--llm-designs-daemon-rust-xs-performance--three-variant-benchmark-as-bottleneck-triangulation-and-fxHasPendingJobs-as-check-and-reset-latch
---

§The-design-includes-an-uncommitted-change-map section that
maps eight discrete change clusters to design documents:

| # | Cluster | Files | Design doc |
|---|---------|-------|------------|
| 1 | XS host function argument fix | 6 files | This design |
| 2 | Reactive pump loop fix | lib.rs lines 1296-1358 | This design |
| 3 | Worker platform refactoring | 8 files | daemon-endor-architecture (cycle 176) |
| 4 | XS heap snapshots + suspend/resume | 9 files | daemon-xs-worker-snapshot (cycle 178) |
| 5 | Benchmark harness | 1 new file | This design |
| 6 | CESU-8 encoding fix | worker_io.rs | This design + cycle 176 |
| 7 | XS block-scoping workaround | daemon_bootstrap.js | This design |
| 8 | Misc (Cargo.lock + Cargo.toml + designs/README) | several | All three |

§The-§working-copy-inventory section serves as §a-map-so-the-
next-agent-can-orient-quickly. §This-is-§designs-as-living-
documents discipline: the design is not just specification but
also §navigation-aid for the in-progress work.

§Compare-to-cycle-184-metering's §Status-section-as-shipped-
artifact-archive. §Both-are-§designs-as-archives but at
different lifecycle points: cycle 184 archives completed work;
cycle 188 archives in-progress work.
