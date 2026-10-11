---
title: "ADR 0024: Distinct project MCP lifecycle"
source: docs/decisions/0024-project-mcp-catalog-hygiene.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, capability-mediated-integrations]
status: current
---

> Abstract: A project-owned MCP server is durable product authority with its own versioned lifecycle, unlike an operator's local server list, a generated application's embedded MCP behavior, or a CLI distribution adapter.

The operator catalog records servers a user chooses to call, while a project may create,
modify, and ship servers it owns. Project servers therefore need the same identity and
pinning discipline as Components, Flavors, skills, and workflows. They are not aliases
for the operator-local catalog established by [ADR 0021](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0021-operator-local-mcp-catalog.md), nor for MCP behavior generated inside an application.

Source: [docs/decisions/0024-project-mcp-catalog-hygiene.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0024-project-mcp-catalog-hygiene.md) at commit `fcc40bc6`.
