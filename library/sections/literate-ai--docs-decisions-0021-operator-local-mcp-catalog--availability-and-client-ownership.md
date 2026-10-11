---
title: "ADR 0021: Availability and client ownership"
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

> Abstract: A named service runs only when both catalog designation and live reachability agree; ADR 0025 later makes `litai` the catalog MCP client while human-facing skills retain catalog-authoring responsibility.

Missing Jira, Slack, or Outlook is a skip rather than grounds to grow another tracker
client, and repository trackers remain with `gh` or `glab`. ADR 0025 supersedes the
original posting and discovery split: the CLI becomes the client, while the session
skill continues to record human-selected ids. Coding-session wrappers must not duplicate
mutagenic envelopes already posted by the CLI.

Source: [docs/decisions/0021-operator-local-mcp-catalog.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0021-operator-local-mcp-catalog.md) at commit `fcc40bc6` (source lines 51-65).
