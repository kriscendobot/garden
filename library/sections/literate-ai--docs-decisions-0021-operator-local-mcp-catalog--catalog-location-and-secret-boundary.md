---
title: "ADR 0021: Catalog location and secret boundary"
source: docs/decisions/0021-operator-local-mcp-catalog.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, capability-mediated-integrations, repository-governance]
status: current
---

> Abstract: A schema-versioned `mcps.json` lives under a platform-resolved user configuration directory and contains server identities only, never tokens, webhooks, bot secrets, or committed project authority.

The original 0.8.0 decision used `$HOME/.config/literate-ai`, honoring an absolute
`LITAI_CONFIG_DIR` and `XDG_CONFIG_HOME`. ADR 0031 later standardized the application
directory through the shared platform adapter and made setup depend on the catalog file
itself rather than unrelated directory contents. The old location remains migration
input, while the schema and secret boundary remain authoritative.

Source: [docs/decisions/0021-operator-local-mcp-catalog.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0021-operator-local-mcp-catalog.md) at commit `fcc40bc6` (source lines 12-15 and 28-35).
