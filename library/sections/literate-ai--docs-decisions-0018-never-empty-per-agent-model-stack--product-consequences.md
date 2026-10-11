---
title: "ADR 0018: Product consequences"
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

> Abstract: Live and attended generation share one isolated per-agent cursor model, Components may change models within sections without rewriting Flavor or pipeline authority, and stack defects become source-located observability events.

The stack becomes product behavior rather than an incidental side effect of live-test
selection. A sectional model change stays local to its authored scope. Session-start and
CLI-override events from ADR 0017 remain selection evidence, distinct from the push/pop
events and current cursor governed here.

Source: [docs/decisions/0018-never-empty-per-agent-model-stack.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0018-never-empty-per-agent-model-stack.md) at commit `fcc40bc6`.
