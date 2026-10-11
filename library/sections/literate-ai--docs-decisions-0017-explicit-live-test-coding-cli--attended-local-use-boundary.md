---
title: "ADR 0017: Attended local-use boundary"
source: docs/decisions/0017-explicit-live-test-coding-cli.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, repository-governance]
status: current
---

> Abstract: Attended workstation generation retains operator choice, PATH selection, and the existing fallback behavior; the deterministic pin applies only to live qualification and release fan-out.

Interactive `generate` and `rebuild` use cases have a human present to choose among
Cursor, Claude, Codex, or OpenCode and respond to provider state. The ADR deliberately
does not generalize its unattended testing contract to that path, keeping test
reproducibility separate from local convenience.

Source: [docs/decisions/0017-explicit-live-test-coding-cli.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0017-explicit-live-test-coding-cli.md) at commit `fcc40bc6`.
