---
title: "ADR 0004: Compatibility"
source: docs/decisions/0004-executable-port-boundaries.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: The less-than-one-day-old unused 0.1 protocol names are removed rather than deprecated, while the one used application import, `BuildAuthorizer`, remains compatible through a re-export of its single canonical shared-port definition.

This is an intentional correction to an unused, less-than-one-day-old `0.1` surface.
The speculative protocol names are removed instead of deprecated because there are no
repository consumers and preserving them would continue to advertise false contracts.
The one used application import, `BuildAuthorizer`, remains compatible through a
re-export of the single canonical protocol.

Source: [docs/decisions/0004-executable-port-boundaries.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0004-executable-port-boundaries.md) at commit `fcc40bc` (source lines 55–61).
