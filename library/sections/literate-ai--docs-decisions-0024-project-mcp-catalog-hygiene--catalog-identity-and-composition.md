---
title: "ADR 0024: Catalog identity and composition"
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

> Abstract: Each project MCP item lives beneath a declared catalog root, owns a directory sentinel named `mcp.md`, and binds a stable identifier, semantic version, and content identity for copy and inheritance composition.

The sentinel follows the same directory-ownership rule as `SKILL.md` and `workflow.md`.
Once the filesystem layout is available, catalog copy and repository inheritance compose
project MCPs by pinned identity rather than by rediscovering unversioned process hints.

Source: [docs/decisions/0024-project-mcp-catalog-hygiene.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0024-project-mcp-catalog-hygiene.md) at commit `fcc40bc6`.
