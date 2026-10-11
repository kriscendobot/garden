---
title: "ADR 0004: Consequences"
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

> Abstract: Fewer shared abstractions are accepted because each now has a caller, implementation, and executable proof; future capabilities can remain architectural vocabulary or use-case-local protocols until their data and authority boundaries justify standardization.

The code now exposes fewer abstractions, but each shared port has a caller, an
implementation, and executable proof. Future adapters may require a small use-case-local
protocol before becoming shared. That cost is preferable to standardizing a signature
before its data and authority boundary are understood.

The architecture vocabulary can still discuss future provider capabilities. A name in
an architecture diagram is not a Python API or a delivery claim until the criteria
above are met.

Source: [docs/decisions/0004-executable-port-boundaries.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0004-executable-port-boundaries.md) at commit `fcc40bc` (source lines 63–72).
