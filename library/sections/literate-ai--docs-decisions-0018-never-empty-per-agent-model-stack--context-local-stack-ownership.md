---
title: "ADR 0018: Context-local stack ownership"
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

> Abstract: Each coding session stores its model stack in context-local state so threads, asynchronous tasks, and agents copy independent cursors instead of mutating one process-global list.

The immutable lexical binding continues to identify locks and caches. The context-local
stack governs live runtime and specification-facing selection, and generation passes its
top frame to the coding CLI. Context copying creates an isolated stack snapshot rather
than shared mutable state across concurrent agents.

Source: [docs/decisions/0018-never-empty-per-agent-model-stack.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0018-never-empty-per-agent-model-stack.md) at commit `fcc40bc6`.
