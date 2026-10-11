---
title: "ADR 0022: Shared channel-envelope context"
source: docs/decisions/0022-channel-author-recipient-vocabulary.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, capability-mediated-integrations]
status: current
---

> Abstract: The same mutation event appears in Jira, Slack, and Outlook, while inbound messages may request work, so a common vocabulary is needed to prevent channel-specific prefixes and distinguish emitted status from actionable input.

Without one envelope, each integration would invent its own markers and agents could not
reliably tell whether Literate AI authored a status message or was named as its recipient.
The decision makes that distinction portable across comment, post, subject, and body
renderings.

Source: [docs/decisions/0022-channel-author-recipient-vocabulary.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0022-channel-author-recipient-vocabulary.md) at commit `fcc40bc6` (source lines 1-16).
