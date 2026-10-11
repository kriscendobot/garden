---
title: "ADR 0013: Normalized resource measurement"
source: docs/decisions/0013-intent-refinement-and-specification-sufficiency.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: Portable authority gives wall, CPU, and GPU measurements normalized meanings, scope, quality, and aggregation rules, while target Flavors and skills choose host APIs and report unavailable observations honestly instead of relabeling wall time.

The illustrative vocabulary defines monotonic job wall time, operating-system-reported
CPU execution for threads contributing accepted work, completed device-kernel duration
attributed to accepted work, a quality of exact, estimated, or unavailable, and a scope
of work unit, worker, or job. Accepted authority must additionally settle concurrency
overlap, rejected or retried work, monotonicity, overflow, and worker-to-job aggregation.

Linux clocks, `perf`, CUDA events, ROCm APIs, permissions, and device counters remain
target details. OS and accelerator Flavors plus implementation skills obtain evidence
that conforms to the portable contract. Missing counters are explicitly unavailable;
wall time must never be mislabeled CPU or GPU time.

Source: [docs/decisions/0013-intent-refinement-and-specification-sufficiency.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0013-intent-refinement-and-specification-sufficiency.md) at commit `fcc40bc6` (source lines 330-381).
