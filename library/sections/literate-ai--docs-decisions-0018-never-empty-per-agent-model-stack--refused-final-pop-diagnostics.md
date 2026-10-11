---
title: "ADR 0018: Refused final-pop diagnostics"
source: docs/decisions/0018-never-empty-per-agent-model-stack.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: A pop at depth one is refused with a warning and structured event that retain the session model and record both Python call-site context and any specification location, making mismatched stack operations visible without making the cursor undefined.

The diagnostic identifies the session CLI and model, caller file, line, function, a short
call chain, and named source path, line, or section when the specification supplied one.
The maintainers choose warning-and-preserve over hard generation failure: the defect is
actionable, but the runtime must never pretend that no model is selected.

Source: [docs/decisions/0018-never-empty-per-agent-model-stack.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0018-never-empty-per-agent-model-stack.md) at commit `fcc40bc6`.
