---
title: "ADR 0025: Headless institutional-memory gap"
source: docs/decisions/0025-cli-operator-mcp-client.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, capability-mediated-integrations]
status: current
---

> Abstract: A local event journal cannot by itself deliver headless or scripted `litai` outcomes to Jira, Slack, or Outlook, so institutional fan-out must work without an interactive coding agent.

This finding supersedes the earlier assumption in
[ADR 0023](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0023-mutagenic-cli-channel-fan-out.md)
that only agent skills should post. The author envelope remains durable locally, but the
CLI now owns the optional delivery attempt when it performed the mutation.

Source: [docs/decisions/0025-cli-operator-mcp-client.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0025-cli-operator-mcp-client.md) at commit `fcc40bc6`.
