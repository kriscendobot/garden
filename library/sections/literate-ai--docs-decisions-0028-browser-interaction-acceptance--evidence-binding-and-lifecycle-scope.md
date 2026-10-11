---
title: "ADR 0028: Evidence binding and lifecycle scope"
source: docs/decisions/0028-browser-interaction-acceptance.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, software-supply-chain, testing]
status: current
---

> Abstract: A browser pass is evidence only for the bound viewport, interaction-contract identity, browser/tool identity, screenshots, captured failures, and outcome, while non-browser deployment units retain lightweight text and HTTP probes.

The new mode is additive and applies only when a frontend unit declares a browser
contract. Its regression suite deliberately includes runtime initialization failure,
unbound scrolling, no-op export, narrow-viewport overflow, and unexpected network use
during local interaction, turning those prior false passes into lifecycle failures.

Source: [docs/decisions/0028-browser-interaction-acceptance.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0028-browser-interaction-acceptance.md) at commit `fcc40bc6`.
