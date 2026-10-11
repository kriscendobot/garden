---
title: "ADR 0025: Skill wrapping and duplicate suppression"
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

> Abstract: Coding-session skills that invoke `litai` rely on its fan-out instead of reposting the same envelope, while interactive release association and inbound mail admission remain separate skill responsibilities.

The release-association skill may still choose a major or minor Jira item and record its
identifier so later CLI events can comment there. Inbound recipient handling stays an
agent skill because mail is already in the session context; the CLI does not become a
mail poller.

Source: [docs/decisions/0025-cli-operator-mcp-client.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0025-cli-operator-mcp-client.md) at commit `fcc40bc6`.
