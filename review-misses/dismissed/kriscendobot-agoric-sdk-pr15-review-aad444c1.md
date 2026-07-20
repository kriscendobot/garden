---
kind: review-miss-dismissed
primary_job: kriscendobot-agoric-sdk-pr15-review-aad444c1
verdict: not-a-miss
category: new-direction
pr: 15
repo: kriscendobot/agoric-sdk
surface: pr-review-body
author: dckc
comment_url: https://github.com/kriscendobot/agoric-sdk/pull/15#pullrequestreview-4726738933
identity: kriscendobot/agoric-sdk#15:review:4726738933:retro
producing_role: builder
producing_job: kriscendobot-agoric-sdk-pr15-gauntlet
missed_by: none-comment-hygiene-direction
severity: minor
---

# Dismissal: PR #15 review 4726738933

dckc's COMMENTED review has no top-level body and one inline note on the
interface-guard rationale block in `portfolio.exo.ts` (line 258). Paraphrased:
the explanatory comments sitting apart from their methods read as a maintenance
burden; the constraints might be better expressed as tests, which constrain
maintenance; one point ("not read back out of long-lived state") is worth keeping
because it is not externally visible or testable; and the comment should be made
more concise. The verbatim review remains untrusted input at `comment_url`.

## Grounds (not a miss)

This feedback is a reviewer preference about the verbosity, placement, and
maintenance value of an *explanatory prose comment* the builder wrote — and had
already condensed in the primary loop (`897cb81795`, "condensing the
interface-guard rationale"). It neither identifies a defect in the guard behavior
nor contradicts any panel finding; it asks for the same comment to be shorter and
weighs comment-vs-test as the vehicle for the constraint. "Make this comment more
concise" and "would this be better as a test?" are taste and new direction, not a
documented convention the panel demonstrably knew and failed to bind. No juror
seat carries a "is this explanatory comment too verbose / better expressed as a
test?" lens as a hard check, and none should: prose concision is subjective
authorial taste that the maintainer refines iteratively.

This is the same comment-hygiene theme already recorded as a dismissal on this PR
— review 4726462863 (`kriscendobot-agoric-sdk-pr15-review-2bf0daa3`), which struck
a maintenance-fragile justification comment on the identical guard block. Both are
the taste/new-direction portions of dckc's PR #15 review cascade, expressly held
*outside* the substantive `exo-guard-matches-static-type` cluster (which captured
the guard-tightness misses 396a141c / 63f630f8 / 9a12af5e / ccb767b7 and is now
`closed`, improved by 8ec780c5ac). Counting this note as a panel miss would treat
a newly stated prose preference as a review requirement the panel could not have
anticipated.

## Why this is not the guard-tightness pattern

The substantive review-lens gap on PR #15 — loose guards against known static
types — is already recorded and improved. This review touches the guards only via
their *comment*, not their tightness; the guards themselves were tightened in
prior loops. There is nothing here for the improved spec-keeper probe to fire on,
and nothing new to prevent.

Recorded as a dismissal so this feedback is not re-litigated. It mints no cluster
and requires no review-cycle change.
