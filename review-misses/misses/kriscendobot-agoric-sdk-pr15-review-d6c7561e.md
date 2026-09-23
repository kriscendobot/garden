---
kind: review-miss
primary_job: kriscendobot-agoric-sdk-pr15-review-d6c7561e
verdict: miss
category: spec-violation
pr: 15
cluster: exo-guard-matches-static-type
repo: kriscendobot/agoric-sdk
surface: pr-review-body
author: dckc
comment_url: https://github.com/kriscendobot/agoric-sdk/pull/15#pullrequestreview-4726532241
identity: kriscendobot/agoric-sdk#15:review:4726532241
producing_role: builder
producing_job: kriscendobot-agoric-sdk-pr15-gauntlet
missed_by: spec-keeper (guard-tightness-vs-known-type lens did not bind)
severity: major
grounds: The PR's completed 16-seat gauntlet approved the exo guard change while affirming loose guards as compatibility-first, despite the pre-existing TypedPatterns convention and later focused review feedback on the same gap.
---

# Miss: PR #15 review 4726532241

The maintainer asked for a focused reconsideration of whether the exo interface
guards enforce their known static types at runtime. The primary response found
more loose argument and return guards, tightened the stable cases, and documented
the deliberate exceptions. This is a paraphrase; the untrusted original remains
only at `comment_url`.

## Grounds (indicts the review process)

The completed `kriscendobot-agoric-sdk-pr15-gauntlet` ran the relevant 16-seat
panel and reported unanimous approval, including a favorable compatibility and
upgrade-safety assessment of loose guards. Earlier PR #15 retros recorded three
major instances in this same pattern, and the primary job for this review found
additional under-specified guards that required correction. The repository's
pre-existing TypedPatterns convention required a guard to match a known static
type as tightly as possible, with any looseness reasoned and documented. The
panel did not apply that convention to this change, so the maintainer had to
surface the same gap again.

This joins `exo-guard-matches-static-type` rather than minting a new cluster:
the failure is the same absent review lens for loose exo argument or return
guards, not a new requirement or a prose preference. It is a major recurrence
after that cluster's prior improvement closed it.
