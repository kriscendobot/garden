---
title: "ADR 0023: Alternatives, consequences, and tests"
source: docs/decisions/0023-mutagenic-cli-channel-fan-out.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: The accepted design lets the CLI post through operator MCPs but refuses to make channel outages transactional or create a Jira issue per mutation, with tests proving exact event emission and fail-open notification behavior.

ADR 0025 supersedes the earlier rejection of an embedded CLI MCP client so headless
events are not missed. The remaining alternatives stay rejected: unavailable
institutional channels cannot undo successful project work, and per-command issue
creation would flood the tracker and destroy release hierarchy. Tests establish that
read-only commands emit nothing, successful mutations emit one author event, and journal
I/O failure leaves command status unchanged.

Source: [docs/decisions/0023-mutagenic-cli-channel-fan-out.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0023-mutagenic-cli-channel-fan-out.md) at commit `fcc40bc6` (source lines 72-92).
