---
title: "ADR 0021: Alternatives and consequences"
source: docs/decisions/0021-operator-local-mcp-catalog.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, repository-governance, testing]
status: current
---

> Abstract: Project storage is rejected because it would turn one maintainer's services into product policy and risk secrets, while empty catalogs remain valid so headless operation never fails for lack of optional integrations.

The accepted design lets interactive sessions create the catalog and lets a bare TTY
offer a limited fallback. Tests override the configuration root and use non-TTY input so
they cannot prompt or write the real home directory. Jira, Slack, and Outlook work is
conditional on the resulting catalog rather than part of the project's required
authority.

Source: [docs/decisions/0021-operator-local-mcp-catalog.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0021-operator-local-mcp-catalog.md) at commit `fcc40bc6` (source lines 67-86).
