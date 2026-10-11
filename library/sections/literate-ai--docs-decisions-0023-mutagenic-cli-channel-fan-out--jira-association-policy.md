---
title: "ADR 0023: Jira association policy"
source: docs/decisions/0023-mutagenic-cli-channel-fan-out.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, capability-mediated-integrations, repository-governance]
status: current
---

> Abstract: Release planning explicitly associates one major-or-minor line with an existing or newly chosen Jira Epic, Story, or Task, preserving Jira hierarchy rules and avoiding one issue per command.

Epic associations can parent later release Tasks through Jira's Parent field; associated
Stories or Tasks receive comments but cannot parent peers. Patch releases reuse the
major-or-minor ticket, Jira versions remain distinct from issue hierarchy, and no
association means notification is skipped rather than creating issue spam.

Source: [docs/decisions/0023-mutagenic-cli-channel-fan-out.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0023-mutagenic-cli-channel-fan-out.md) at commit `fcc40bc6` (source lines 57-64).
