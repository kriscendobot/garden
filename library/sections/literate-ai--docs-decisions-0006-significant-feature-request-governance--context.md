---
title: "ADR 0006: Context for significant-feature governance"
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

> Abstract: A mid-patch-release sample audit exposed substantial unscheduled design work that was about to begin from chat direction without a decision record, review point, or durable why-to-delivery link, revealing that existing ADR and roadmap mechanisms lacked a required order and significance boundary.

- Status: Accepted
- Date: 2026-08-19
- Decision owners: literate-ai maintainers
- Roadmap: n/a — this ADR establishes the process that governs future roadmap entries

During the 0.5.1 patch-release cycle, a sample-portfolio audit (requested mid-release,
outside the four bug fixes the release branch actually needed) surfaced real findings:
12 of 17 `specification-to-source` skills are exercised by zero samples or components,
Flavor coverage is concentrated and mostly dormant under default gates, and two new
samples ship without any conformance-harness wiring. Those findings are real, but acting
on them — pinning skill selections, authoring roughly a dozen new samples, re-pinning
Flavor axes across existing samples — is a substantial body of new work with real
design decisions embedded in it (which orphaned skills are worth keeping vs. retiring,
what a "thin" sample must still prove, how newly-pinned languages interact with the
existing conformance matrix). That work was about to start directly from a chat
directive, with no separate record of the decision itself, no review point before
authoring a dozen new specifications, and no durable link between "why we did this" and
"what shipped."

This is not the first time a mid-cycle idea has expanded scope without a written
decision preceding the work. The framework already has two separate mechanisms that
individually do part of this job — `docs/decisions/*.md` (ADRs, for architecture and
process decisions) and `skills/agent/record-user-directed-work/SKILL.md` (turning
direction into a roadmap queue item with evidence checkboxes) — but nothing connects
them in a required order, and nothing distinguishes "significant" scope-expanding work
from an ordinary bug fix or small follow-up that can go straight to the roadmap queue.

Source: [docs/decisions/0006-significant-feature-request-governance.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0006-significant-feature-request-governance.md) at commit `fcc40bc` (source lines 1–30).
