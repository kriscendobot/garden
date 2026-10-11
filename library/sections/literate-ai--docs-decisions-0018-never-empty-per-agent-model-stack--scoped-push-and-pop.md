---
title: "ADR 0018: Scoped push and pop"
source: docs/decisions/0018-never-empty-per-agent-model-stack.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: Entering a Component, Flavor role, skill, or authored section pushes only when model or CLI changes, leaving the scope restores its enclosing frame, and an explicit authored push always creates a frame even when its selector matches the current top.

Conditional automatic pushes avoid redundant runtime frames while preserving lexical
nesting. Explicit operations have different semantics: the author may intentionally
establish a matching frame that a later explicit pop consumes. Sibling scopes therefore
resume the same model cursor their common parent held.

Source: [docs/decisions/0018-never-empty-per-agent-model-stack.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0018-never-empty-per-agent-model-stack.md) at commit `fcc40bc6`.
