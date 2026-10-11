---
title: "ADR 0008: Failure evidence and existing resilience patterns"
source: docs/decisions/0008-samples-gate-live-generation-resilience.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: The sample runner discarded all completed work after one exception, although Literate AI already had bounded whole-subprocess retry and stage-checkpoint precedents; later failures showed cache custody and truncated diagnostics must remain visible so resilience does not hide misconfiguration.

The sample runner propagated the first exception from parallel execution and discarded
the rest of a completed matrix. A retry restarted every sample. This differs from hard
denial fallback, which changes providers after an immediate authentication or quota
error.

Existing retry code already reset the generation workspace and reran the whole coding
CLI subprocess for one probabilistic metadata error, bounded to two extra attempts.
Existing unit-test and release runners also checkpointed completed stages to JSON so
a rerun resumed at the last successful stage.

The 0.5.2 backport sharpened the evidence: six cold rebuilds failed across Rust,
service-stack, and JavaScript/Bazel cases, yet each later passed unchanged. Warm
`OBJ_DIR` custody avoided regeneration while cold custody exposed failures. Three
failures were actually an unwritable runtime-root misconfiguration whose useful CLI
message was lost when the driver retained only the last four stderr lines. Retry must
not replace complete diagnostic output or spend its budget on deterministic setup
errors.

Source: [docs/decisions/0008-samples-gate-live-generation-resilience.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0008-samples-gate-live-generation-resilience.md) at commit `fcc40bc6` (source lines 68-125).
