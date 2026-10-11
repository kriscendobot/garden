---
title: "ADR 0013: Tradeoffs and binding constraints"
source: docs/decisions/0013-intent-refinement-and-specification-sufficiency.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, repository-governance, testing]
status: current
---

> Abstract: ADR 0013 rejects complete-specification prerequisites, silent agent inference, global maturity levels, generated-test sufficiency, a universal formal language, and sample-first hard-coding; it binds any implementation to reviewed per-concern refinement with non-authoritative drafts and independent acceptance.

The chosen approach lets expert users author complete Components directly without making
that the only path. It avoids converting model assumptions into product behavior,
mistaking a candidate's internal consistency for intent alignment, or inventing a DSL
where narrow existing representations suffice. The pi sample follows the general
refinement contract rather than defining it by example.

The benefit is a user-visible answer to what must be specified next, with depth applied
only where correctness needs it. The cost is a new versioned contract family, service,
CLI, review workflow, and evidence chain, plus honest separation of deterministic and
model-proposed findings. Binding constraints require refinement before authoring and
generation; content-identified drafts; per-concern authority; independent decidability;
blocking-decision closure; explicit review of assumptions; atomic non-generating
acceptance; preserved authority layers; one entrypoint per executable Component; and a
provider-neutral, independently verified reference sample.

Source: [docs/decisions/0013-intent-refinement-and-specification-sufficiency.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0013-intent-refinement-and-specification-sufficiency.md) at commit `fcc40bc6` (source lines 402-484).
