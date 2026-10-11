---
title: "ADR 0006: Consequences"
source: docs/decisions/0006-significant-feature-request-governance.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, repository-governance]
status: current
---

> Abstract: The ADR-first sequence intentionally slows mid-release scope expansion, while imposing the maintenance obligation that proposal status stay honest across review; the existing roadmap mechanism remains unchanged except that significant requests must arrive with an accepted upstream decision.

`skills/agent/release-project/SKILL.md` gains a step requiring this ADR-first sequence
before a release absorbs new scope beyond its already-planned fixes. This adds real
friction — a written decision and an explicit review point before work that used to
start immediately from a chat directive — which is the intended effect: it is meant to
slow down exactly the moment where scope quietly expands mid-release, not to slow down
the release's already-scoped work.

The cost is one more artifact to keep current: an ADR whose `Status` is stale (left at
`Proposed` after acceptance, or `Accepted` without ever having been reviewed) is worse
than no ADR, so the discipline only pays off if the status field is honestly maintained
across the planning cycle. `record-user-directed-work` is unchanged in mechanics; it
gains one required upstream input for the significant-request case and remains the
sole roadmap-recording path for everything else.

Source: [docs/decisions/0006-significant-feature-request-governance.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0006-significant-feature-request-governance.md) at commit `fcc40bc` (source lines 72–86).
