---
title: "ADR 0022: Envelope schema and safe fields"
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

> Abstract: The versioned channel-event schema carries a fixed marker, author-or-recipient role, bounded event kind, project identity, and optional command metadata behind a human first line, while excluding credentials, private prompts, and worker identities.

The role is either `author`, meaning Literate AI wrote the message, or `recipient`,
meaning it may request action. Kinds cover CLI mutations, inbound tasks, and publication
summaries. A parseable trailer follows human-readable text and is shared by every channel
instead of using channel-specific prefixes.

Source: [docs/decisions/0022-channel-author-recipient-vocabulary.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0022-channel-author-recipient-vocabulary.md) at commit `fcc40bc6` (source lines 18-31).
