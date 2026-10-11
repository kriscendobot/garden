---
title: "ADR 0024: Release scope and rejected flattening"
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

> Abstract: The initial release commits to layout, schema, and hygiene without blocking operator-catalog or channel work on full composition, and rejects both embedding project servers under agent skills and treating the operator catalog as the only MCP record.

Agent skills may wrap Python, but they are not the MCP process and must not own project
server identity. Conversely, an operator's catalog cannot version a server shipped by a
project. The release may add catalog composition and an example later, but the distinct
catalog kind is already the governing boundary.

Source: [docs/decisions/0024-project-mcp-catalog-hygiene.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0024-project-mcp-catalog-hygiene.md) at commit `fcc40bc6`.
