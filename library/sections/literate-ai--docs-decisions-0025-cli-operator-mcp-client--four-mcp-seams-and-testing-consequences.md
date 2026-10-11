---
title: "ADR 0025: Four MCP seams and testing consequences"
source: docs/decisions/0025-cli-operator-mcp-client.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [capability-mediated-integrations, testing, software-supply-chain]
status: current
---

> Abstract: Operator-catalog MCPs, project-owned MCPs, generated application's embedded MCPs, and in-page WebMCP tools keep separate identities, secrets, and generation requirements, while CLI tests use an injected fake transport rather than live institutional services.

The CLI's official MCP dependency does not imply that generated Components depend on
the same Python package. Application generation selects the official SDK appropriate to
its language and Flavor. This separation avoids turning one integration seam into a
product-wide dependency or requiring Jira, Slack, or Outlook during tests.

Source: [docs/decisions/0025-cli-operator-mcp-client.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0025-cli-operator-mcp-client.md) at commit `fcc40bc6`.
