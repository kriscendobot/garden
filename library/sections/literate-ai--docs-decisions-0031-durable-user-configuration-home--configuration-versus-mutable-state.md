---
title: "ADR 0031: Configuration versus mutable state"
source: docs/decisions/0031-durable-user-configuration-home.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, capability-security]
status: current
---

> Abstract: Authored configuration and changing observations or event journals receive separate platform-resolved roots even when one migration transaction moves both.

The distinction prevents mutable operational history from masquerading as user-authored policy. Cache, data, installation, temporary, and target-machine paths likewise retain independent semantic owners instead of collapsing into a single home-relative directory.

Source: [docs/decisions/0031-durable-user-configuration-home.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0031-durable-user-configuration-home.md) at commit `fcc40bc6`.
