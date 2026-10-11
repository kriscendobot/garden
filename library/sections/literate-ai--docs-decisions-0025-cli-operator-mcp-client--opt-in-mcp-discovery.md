---
title: "ADR 0025: Opt-in MCP discovery"
source: docs/decisions/0025-cli-operator-mcp-client.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [capability-mediated-integrations, repository-governance]
status: current
---

> Abstract: MCP discovery is a one-invocation, off-by-default probe that may report reachability from catalog command hints or a registry-use server, but cannot author catalog policy, write secrets, or become a daemon.

Default-off discovery prevents every ordinary command, including CI, from unexpectedly
starting processes or touching the network. Explicit discovery supplements rather than
replaces the operator-owned catalog configuration flow.

Source: [docs/decisions/0025-cli-operator-mcp-client.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0025-cli-operator-mcp-client.md) at commit `fcc40bc6`.
