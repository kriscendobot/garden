---
title: "ADR 0018: Specification-language operations"
source: docs/decisions/0018-never-empty-per-agent-model-stack.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, repository-governance]
status: current
---

> Abstract: Component and Flavor specifications can issue push, pop, depth, and current operations through interpreted Markdown directives or additive version-two model-selection JSON, without changing version-one documents or treating directives as prompt decoration.

The converter executes mutation and query operations against the model cursor. Depth and
current are read-only; push and pop change runtime selection. This feature does not wait
for the broader
[literate-markdown version-two proposal](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0011-component-domain-structure-literate-markdown-v2.md):
HTML-comment directives and an additive model-selection schema are sufficient for the
bounded cursor contract.

Source: [docs/decisions/0018-never-empty-per-agent-model-stack.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0018-never-empty-per-agent-model-stack.md) at commit `fcc40bc6`.
