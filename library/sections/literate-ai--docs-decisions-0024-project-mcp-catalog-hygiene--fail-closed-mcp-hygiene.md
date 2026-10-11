---
title: "ADR 0024: Fail-closed MCP hygiene"
source: docs/decisions/0024-project-mcp-catalog-hygiene.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [capability-mediated-integrations, repository-governance, software-supply-chain]
status: current
---

> Abstract: Project MCP validation rejects tracked secrets, duplicate copies of an identity, MCP directives hidden in source-generation skills, operator-local identifiers treated as project policy, and modifications whose resulting bytes are not pinned.

These rejects preserve three boundaries at once: credentials remain outside repository
authority, catalog identity has one canonical copy, and generation prompts do not become
an undeclared prerequisite for operating the server. A modification is incomplete until
the new content identity is recorded.

Source: [docs/decisions/0024-project-mcp-catalog-hygiene.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0024-project-mcp-catalog-hygiene.md) at commit `fcc40bc6`.
