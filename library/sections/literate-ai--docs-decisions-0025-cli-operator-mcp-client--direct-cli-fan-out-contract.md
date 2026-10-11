---
title: "ADR 0025: Direct CLI fan-out contract"
source: docs/decisions/0025-cli-operator-mcp-client.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, capability-mediated-integrations, repository-governance]
status: current
---

> Abstract: After a successful mutagenic command, the CLI journals one author envelope and attempts fail-open delivery through operator-catalog servers whose declared uses match configured institutional channels.

The preferred transport is the importable official Python `mcp` package. A bounded
stdio JSON-RPC client may instead use a catalog-provided command argument vector; an
empty command is never spawned. Missing tools and outages produce a stderr skip rather
than rolling back successful project work, and tokens remain outside version control.

Source: [docs/decisions/0025-cli-operator-mcp-client.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0025-cli-operator-mcp-client.md) at commit `fcc40bc6`.
