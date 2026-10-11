---
title: "ADR 0013: Independent decidability and sufficiency states"
source: docs/decisions/0013-intent-refinement-and-specification-sufficiency.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-30
source_authors: [Jordan Hubbard]
ingested: 2026-10-11
ingested_by: scholar
topics: [agentic-sdlc, testing]
status: current
---

> Abstract: A concern is sufficient only when accepted authority and declared target evidence let an independent verifier decide observable correctness without trusting the generated implementation, with all other cases classified into explicit blocking or deliberate-exclusion states.

Public shapes must be bounded, typed, and versioned unless an extension point is
deliberately open. Observable arithmetic, ordering, transitions, retries, and errors
cannot fall to convention. Vague terms such as fast, real time, progress, CPU time, and
stream results require measurable semantics. Generated tests remain current-state
evidence rather than an independent oracle, and unknown product choices never become
implicit model discretion.

Findings are per Component and concern: `sufficient`, `needs-decision`,
`needs-authority`, `target-unresolved`, `unsupported-representation`, or
`out-of-scope`. Only sufficient and deliberately excluded concerns are non-blocking.
An exclusion records who made it and why, and cannot bypass security, validation, or an
already accepted requirement.

Source: [docs/decisions/0013-intent-refinement-and-specification-sufficiency.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/decisions/0013-intent-refinement-and-specification-sufficiency.md) at commit `fcc40bc6` (source lines 113-146).
