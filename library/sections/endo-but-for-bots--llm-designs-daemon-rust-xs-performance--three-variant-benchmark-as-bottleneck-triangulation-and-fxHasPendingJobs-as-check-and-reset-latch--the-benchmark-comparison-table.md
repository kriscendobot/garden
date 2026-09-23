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
title: §The-benchmark-comparison-table
parent: endo-but-for-bots--llm-designs-daemon-rust-xs-performance--three-variant-benchmark-as-bottleneck-triangulation-and-fxHasPendingJobs-as-check-and-reset-latch
---

§Before-fixes (with 1ms sleep):

| Operation | Node.js | Rust+XS | Rust+Node |
|-----------|---------|---------|-----------|
| ping | 0.3ms | 5.8ms | 5.4ms |
| eval_warm | 2.0ms | 44.7ms | 43.7ms |
| storeValue_lookup | 0.8ms | 47.9ms | 49.0ms |

§After-fixes:

| Operation | Node.js | Rust+XS | Rust+Node | Speedup |
|-----------|---------|---------|-----------|---------|
| ping | 0.3ms | 0.6ms | 0.6ms | 9.7x |
| eval_warm | 1.7ms | 2.5ms | 3.0ms | 17.9x |
| storeValue_lookup | 1.0ms | 1.8ms | 2.2ms | 26.6x |

§The-§speedup-column compares Rust+XS-before vs Rust+XS-after.
§Numbers-cited in three places (summary + before-table + after-
table + speedup-column) for §triangulation-from-multiple-angles.

§Compare-to-cycle-184-metering's §all-seven-phases-Complete
status section with file-paths-and-test-counts. §Both-record-
empirical-evidence-of-design-claims.
