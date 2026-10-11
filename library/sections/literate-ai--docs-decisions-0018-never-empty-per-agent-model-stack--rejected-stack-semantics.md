---
title: "ADR 0018: Rejected stack semantics"
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

> Abstract: The ADR rejects a process-global stack, implicit-only lexical inference, depth zero, hard failure on the last-frame pop, and coupling sectional model operations to the broader Markdown-version migration.

A global list breaks concurrent isolation. Lexical inference alone cannot express
section-local pushes or specification queries. Empty depth leaves generation without a
defined cursor. Hard failure contradicts the accepted warning-and-preserve behavior,
while waiting for a separate domain-structure proposal unnecessarily blocks this bounded
runtime feature.

Source: [docs/decisions/0018-never-empty-per-agent-model-stack.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0018-never-empty-per-agent-model-stack.md) at commit `fcc40bc6`.
