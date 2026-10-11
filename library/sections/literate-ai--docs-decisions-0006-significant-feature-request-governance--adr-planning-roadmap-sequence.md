---
title: "ADR 0006: ADR, planning, and roadmap sequence"
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

> Abstract: The maintainers require scope-expanding or design-bearing feature requests to proceed in order: author a proposed ADR, run a real accept/amend/reject planning review with honest status, then put accepted concrete subtasks on the current release roadmap with bidirectional links; ordinary fixes and already-specified work may go directly to the queue.

A **significant feature request** — new capability, a scope expansion beyond what a
release or task was originally cut for, or a change that embeds a real design decision
(not just an implementation detail) — follows this order, and does not skip a step:

1. **Author an ADR in `docs/decisions/`** before any implementation lands. The ADR states
   the context, the decision, and its consequences, using the existing numbered format
   (see `docs/decisions/0001` through `0005` for the shape: Status/Date/Decision
   owners/Roadmap header fields, then Context, Decision, and a closing consequences
   section). The ADR is where the design decisions live — what's in scope, what's
   deliberately deferred or rejected, and why — not the roadmap queue, which only tracks
   execution state.
2. **Run a planning cycle on the ADR before implementing it.** Whoever directs the work
   reviews the ADR's proposed decision and explicitly accepts, amends, or rejects it
   before any subtask begins. A plan is not a formality to produce and immediately act
   on in the same turn; the review point is real. An ADR's `Status` field records the
   outcome (`Proposed` while under review, `Accepted` once approved, `Rejected` or
   `Superseded` otherwise) and must reflect the actual state, not be defaulted to
   `Accepted` on creation.
3. **Add the accepted ADR's concrete subtasks to the roadmap for the release currently
   in progress**, via `skills/agent/record-user-directed-work/SKILL.md`'s existing
   allocation and evidence-checklist mechanism. The roadmap item links back to its
   owning ADR instead of restating the design; the ADR links forward to its roadmap
   item once one exists, so either document leads a reader to the other.

**What counts as "significant"** is a judgment call, not a bright line, but the
sample-portfolio case is the calibrating example: work that (a) wasn't part of the
release's original committed scope, (b) involves a real design choice with more than
one defensible answer, and (c) will take meaningfully longer than the task that
surfaced it. An ordinary bug fix, a formatting correction, a one-file documentation
edit, or work already fully specified by an existing ADR does not need a new one —
route it straight to `record-user-directed-work`'s roadmap queue as today. When in
doubt, the cost of writing a short ADR is small relative to the cost of a dozen new
specifications landing without one.

**This applies to every Literate AI project**, not only this framework repository —
it is process guidance, not a framework-specific mechanic, so it belongs in the
project-generic release-engineering skill rather than a framework-only document.

Source: [docs/decisions/0006-significant-feature-request-governance.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0006-significant-feature-request-governance.md) at commit `fcc40bc` (source lines 32–70).
