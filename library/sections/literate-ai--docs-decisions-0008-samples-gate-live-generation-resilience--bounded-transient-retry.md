---
title: "ADR 0008: Bounded transient retry"
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

> Abstract: The sample gate retries one sample's whole generation attempt only for explicitly classified transient errors, with two configurable extra attempts by default; deterministic content, specification, permission, and build defects still fail promptly.

The runner retries `coding_cli.timeout`, `coding_cli.generation_failed`, and only
additional error codes confirmed in practice to succeed on retry. The retry unit is
one sample's full generation attempt, not downstream parsing of an already-bad result.
The default budget is two extra attempts and remains configurable.

The allowlist is conservative. It does not catch every exception, does not turn a
genuine build or specification defect into a pass, and remains separate from
hard-denial CLI fallback. Exhausting the budget propagates the sample failure.

Source: [docs/decisions/0008-samples-gate-live-generation-resilience.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0008-samples-gate-live-generation-resilience.md) at commit `fcc40bc6` (source lines 127-140).
