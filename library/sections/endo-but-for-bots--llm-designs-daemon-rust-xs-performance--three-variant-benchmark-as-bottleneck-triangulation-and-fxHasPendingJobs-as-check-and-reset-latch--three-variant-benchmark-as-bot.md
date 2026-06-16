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
title: Three-variant benchmark as bottleneck triangulation, fxHasPendingJobs as check-and-reset latch, and two-wrong-fixes considered before three-phase drain loop
parent: endo-but-for-bots--llm-designs-daemon-rust-xs-performance--three-variant-benchmark-as-bottleneck-triangulation-and-fxHasPendingJobs-as-check-and-reset-latch
---

> §Designs-lane after cycle 187's chat-lane. §The-twenty-
> second-consecutive designs/chat alternation cycle (166-188).
> §Status: **Active** — a §living-design that captures the
> diagnosis + fix + benchmark + remaining-optimization map.
> §Cycle-184-daemon-xs-worker-metering's §three-Dependencies
> table named this design as the "reactive pump loop
> integration" sibling.

`daemon-rust-xs-performance.md` (592 lines, Created 2026-04-16,
Updated 2026-04-17) records the §performance-investigation
that produced two bug fixes (XS host argument off-by-one + 1ms
sleep in pump loop) and a three-variant benchmark harness that
triangulates the bottleneck.

§The-single-most-structurally-interesting-move is §three-
variant-benchmark-as-bottleneck-triangulation: Node.js vs
Rust+XS vs Rust+Node. §The-comparison-decomposes-costs because
Rust+XS and Rust+Node differ §only-in-worker-platform; Rust+
Node and Node.js differ §only-in-supervisor. §If-Rust+XS ≈
Rust+Node, the bottleneck lives in the supervisor (not the
worker). §This-is-the-§controlled-experiment discipline.
