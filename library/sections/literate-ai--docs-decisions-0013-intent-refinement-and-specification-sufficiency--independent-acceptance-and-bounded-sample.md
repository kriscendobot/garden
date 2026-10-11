---
title: "ADR 0013: Independent acceptance and bounded sample"
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

> Abstract: A future pi sample must use independent reference vectors, properties, a separate small-input oracle, boundary and lifecycle probes, and exact performance bindings, while bounding its first scope to portable CPU service composition plus one optional accelerator target.

Acceptance cannot use generated code to establish expected digits. It combines
content-pinned prefixes or vectors, precision and bounds properties, deterministic
partition checks, CPU/GPU agreement, an independent oracle or interval test, invalid
requests, reconnect and cancellation behavior, terminal states, and measurement schema
and unavailability checks. Performance claims name the host, workload, warm-up,
concurrency, measurement method, and tolerance; otherwise they remain ambiguous.

The recommended initial sample has one coordinator, browser frontend, and worker set;
requires CPU and optionally CUDA; accepts one bounded algorithm and precision contract;
uses a versioned reconnectable stream; specifies cancellation and worker-loss retries;
and normalizes timing. It deliberately avoids claims of internet-scale scheduling,
arbitrary accelerators, production multi-tenancy, and universal counters, while proving
the provider-neutral refinement workflow itself.

Source: [docs/decisions/0013-intent-refinement-and-specification-sufficiency.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0013-intent-refinement-and-specification-sufficiency.md) at commit `fcc40bc6` (source lines 383-400).
