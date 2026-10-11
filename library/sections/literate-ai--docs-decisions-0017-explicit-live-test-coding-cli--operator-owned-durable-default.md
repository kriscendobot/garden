---
title: "ADR 0017: Operator-owned durable default"
source: docs/decisions/0017-explicit-live-test-coding-cli.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, repository-governance]
status: current
---

> Abstract: The durable live-test launcher and model belong in ignored operator configuration, with inert examples in the repository, while project authority remains vendor-neutral and credentials remain only in process environment.

The ADR originally extends `literate.test.json`; the pinned
[ADR 0031 amendment](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0031-durable-user-configuration-home.md)
moves that file to project-scoped durable user configuration without changing selection
semantics. An incomplete or unknown CLI fails closed. Neither committed project policy,
samples, Flavors, nor skills name a spend-bearing vendor default, and configuration
files never carry secrets.

Source: [docs/decisions/0017-explicit-live-test-coding-cli.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0017-explicit-live-test-coding-cli.md) at commit `fcc40bc6`.
