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
title: §The-three-variant-benchmark (the spine)
parent: endo-but-for-bots--llm-designs-daemon-rust-xs-performance--three-variant-benchmark-as-bottleneck-triangulation-and-fxHasPendingJobs-as-check-and-reset-latch
---

| Variant | Supervisor | Worker | What it isolates |
|---------|------------|--------|------------------|
| Node.js | Node.js process | Node.js subprocess workers | Baseline (in-process CapTP) |
| Rust+XS | Rust supervisor | XS workers | Both Rust supervisor + XS engine |
| Rust+Node | Rust supervisor | Node.js subprocess workers | Just Rust supervisor (worker = Node.js as baseline) |

§A-third-variant (Rust+Node) was added to §isolate-supervisor-
overhead-from-worker-overhead. §Without-it, a slow Rust+XS
result could be either the Rust supervisor's fault or the XS
worker's fault. §With-Rust+Node, the comparison is decisive:

> The Rust+XS and Rust+Node columns being nearly identical
> confirmed the bottleneck was in the manager's message bus,
> not in the worker platform.

§The-§nearly-identical observation is the §triangulation
result. §If-both-Rust-variants-are-slow-equally, the slowness
is upstream of the worker.

§Compare-to-cycle-182-debugger's §three-option-architectural-
decision-table and cycle 178-snapshot's §three-axes-of-
snapshot-incompatibility. §This-design's §three-variant-
benchmark is a §three-way-experimental-decomposition (rather
than a three-option-design-decision).
