---
title: "ADR 0023: Inbound Outlook authority"
source: docs/decisions/0023-mutagenic-cli-channel-fan-out.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, capability-mediated-integrations, repository-governance]
status: current
---

> Abstract: Outlook mailbox authentication plus a valid recipient envelope can create a user-directed-work draft, but message content never directly becomes specification, lock, catalog, or execution authority.

Unmarked mail is ignored. Marked inbound content crosses only into the durable queue,
where later project rules govern execution. This preserves a clean boundary between
authenticated transport identity and authority to mutate a project.

Source: [docs/decisions/0023-mutagenic-cli-channel-fan-out.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0023-mutagenic-cli-channel-fan-out.md) at commit `fcc40bc6` (source lines 66-70).
