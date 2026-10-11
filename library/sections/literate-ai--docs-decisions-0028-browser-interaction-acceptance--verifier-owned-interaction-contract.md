---
title: "ADR 0028: Verifier-owned interaction contract"
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

> Abstract: Independent browser acceptance declares startup, viewports, accessible landmarks, interactions, observable postconditions, overflow and request-count checks, and automatic rejection on console, page, request, or HTTP errors.

The verifier owns this contract separately from generated tests. Supported interactions
include click, select, fill, scroll, and keyboard input; postconditions may inspect text,
state, ARIA, row identity, counts, or downloads. Screenshots and accessibility snapshots
are diagnostics rather than substitutes for the behavioral assertions.

Source: [docs/decisions/0028-browser-interaction-acceptance.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0028-browser-interaction-acceptance.md) at commit `fcc40bc6`.
