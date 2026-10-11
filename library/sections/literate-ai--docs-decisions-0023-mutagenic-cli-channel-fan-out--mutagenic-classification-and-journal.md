---
title: "ADR 0023: Mutagenic classification and journal"
source: docs/decisions/0023-mutagenic-cli-channel-fan-out.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, repository-governance]
status: current
---

> Abstract: One classifier distinguishes commands that change project, lock, generated source, rebuild, or release state from read-only operations, then records each successful mutation once and treats notification failure as non-transactional.

Initialization, update, reparenting, catalog copies, lock writes, generation, rebuild
writes, and release preparation, publication, and branch advance are mutagenic. Help,
version checks, read-only planning, validation, tracker inspection, probes, unrecorded
documentation review, and lock checks are not. On success the CLI writes an author
envelope and fans it out through available catalog MCPs. Journal or channel failure is a
stderr skip and never rolls back the mutation; wrappers must not duplicate the event.

Source: [docs/decisions/0023-mutagenic-cli-channel-fan-out.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0023-mutagenic-cli-channel-fan-out.md) at commit `fcc40bc6` (source lines 29-55).
