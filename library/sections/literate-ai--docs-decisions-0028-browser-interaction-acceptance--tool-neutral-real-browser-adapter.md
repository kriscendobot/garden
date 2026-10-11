---
title: "ADR 0028: Tool-neutral real-browser adapter"
source: docs/decisions/0028-browser-interaction-acceptance.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: The acceptance schema describes browser-independent viewports, actions, postconditions, and failure classes, with Playwright as the first infrastructure adapter rather than as the contract itself.

Keeping tool vocabulary behind a port allows another browser driver without rewriting
the acceptance specification. DOM snapshots or rendered text are rejected as primary
oracles because they cannot establish that scripts execute, event bindings work, or
runtime errors stay absent.

Source: [docs/decisions/0028-browser-interaction-acceptance.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0028-browser-interaction-acceptance.md) at commit `fcc40bc6`.
