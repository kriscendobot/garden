---
title: "ADR 0022: Parsing, alternatives, and consequences"
source: docs/decisions/0022-channel-author-recipient-vocabulary.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: Python owns shared formatting and inbound parsing, tests round-trip all channel shapes, and the ADR rejects both subject-only conventions and treating email as specification authority.

Jira comments, Slack posts, and Outlook subjects and bodies render the same typed
contract; the parser is the inbound admission gate. Channel-specific subjects would
drift, while direct email authority would let an untrusted inbox bypass the durable work
queue. Any future expansion of the envelope remains subject to significant-feature
governance.

Source: [docs/decisions/0022-channel-author-recipient-vocabulary.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0022-channel-author-recipient-vocabulary.md) at commit `fcc40bc6` (source lines 39-59).
