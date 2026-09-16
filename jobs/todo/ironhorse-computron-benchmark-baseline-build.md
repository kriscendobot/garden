---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-16T05:28:03Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# builder: execute the benchmark-established computron-baseline plan for Ironhorse

Execute the plan produced by the sibling design job
`ironhorse-computron-benchmark-baseline-design`. Start by reading that design's
landed doc under `designs/` and its tada report
(`journal/jobs/tada/ironhorse-computron-benchmark-baseline-design.md`) for the
execution steps, decisions, and any follow-ups.

Source directive (maintainer kriskowal, PR #1282 review comment):
https://github.com/endojs/endo-but-for-bots/pull/1282#issuecomment-5692322970

Goal: implement the benchmark-based baseline regime the plan specifies —
re-expressing the range-constraining computron tests that PR #1282 removed as
benchmark-established baselines/bounds for representative loads, modelling
built-ins whose cost is polynomial in input magnitude/size. Reconcile with PR
#1282 exactly as the plan directs (revise the PR in place, supersede it, or
partial keep). This constrains Ironhorse's OWN meter against measured CPU-time
load — NOT XS-computron parity (accuracy-over-parity doctrine holds).

If the plan's execution is itself large and naturally decomposes into ordered
parts, orchestrate sub-builds rather than piling loose jobs. Open a PR through
the gardening flow (ensure-pr.sh) for the executed work per the plan.
