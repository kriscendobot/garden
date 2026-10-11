---
title: "ADR 0028: Text-only frontend false passes"
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

> Abstract: HTTP-text acceptance falsely passed generated pages with runtime errors, missing content, broken event handlers, no-op controls, incorrect virtualization, and mobile overflow because it never executed the browser-observable behavior.

Generated unit tests did not close the gap because a generator can satisfy tests it also
produces. The missing enforcement boundary is independent acceptance with a real engine
that executes scripts, fires events, lays out the document, and reports runtime failure.

Source: [docs/decisions/0028-browser-interaction-acceptance.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0028-browser-interaction-acceptance.md) at commit `fcc40bc6`.
