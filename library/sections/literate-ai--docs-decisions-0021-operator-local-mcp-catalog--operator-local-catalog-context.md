---
title: "ADR 0021: Operator-local catalog context"
source: docs/decisions/0021-operator-local-mcp-catalog.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, capability-mediated-integrations]
status: current
---

> Abstract: Jira, Slack, and Outlook integrations need a durable list of MCP servers chosen by one operator, but that list is neither project authority nor a framework dependency and must stay out of project configuration and version control.

Agents can already receive MCP connections from their host, but `litai` lacked a catalog
and first-run setup. An organization may offer a static list or registry as an optional
discovery source. Neither service becomes required, and the selected integrations remain
local to the operator rather than portable product policy.

Source: [docs/decisions/0021-operator-local-mcp-catalog.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0021-operator-local-mcp-catalog.md) at commit `fcc40bc6` (source lines 1-27).
