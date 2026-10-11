---
title: "ADR 0022: Inbound authority boundary"
source: docs/decisions/0022-channel-author-recipient-vocabulary.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, capability-mediated-integrations, repository-governance]
status: current
---

> Abstract: Author events are status, but recipient text remains untrusted inbox material until recorded as user-directed work; neither marked nor unmarked inbound text may directly mutate specifications, locks, or catalogs.

Unmarked or spoofed messages are ignored. A valid recipient envelope identifies an
admission candidate, not project authority: the durable queue operation is the boundary
that records the request before later execution. This separates transport
authentication and parsing from authority to change project state.

Source: [docs/decisions/0022-channel-author-recipient-vocabulary.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0022-channel-author-recipient-vocabulary.md) at commit `fcc40bc6` (source lines 33-37).
