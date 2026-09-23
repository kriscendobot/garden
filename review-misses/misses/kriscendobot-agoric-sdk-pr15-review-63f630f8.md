---
kind: review-miss
primary_job: kriscendobot-agoric-sdk-pr15-review-63f630f8
verdict: miss
category: spec-violation
pr: 15
cluster: exo-guard-matches-static-type
repo: kriscendobot/agoric-sdk
surface: pr-review-body
author: dckc
comment_url: https://github.com/kriscendobot/agoric-sdk/pull/15#pullrequestreview-4726472818
identity: kriscendobot/agoric-sdk#15:review:4726472818:retro
producing_role: builder
producing_job: kriscendobot-agoric-sdk-pr15-gauntlet
missed_by: spec-keeper (structural gap — no code-panel seat carries the guard-tightness-vs-known-type lens)
severity: major
---

# Miss: PR #15 review 4726472818

The maintainer's review directs that the exo methods' `M.any()` return guards be
tightened to the precise shapes their static return types already describe,
rather than left as the catch-all the PR shipped. (Paraphrase; the verbatim
review is untrusted input at `comment_url`.)

## Grounds (indicts the review process)

This review is one entry in the same guard-tightness cascade the prior confirmed
PR #15 miss already characterizes: the full 16-seat gauntlet
(`kriscendobot-agoric-sdk-pr15-gauntlet`) returned unanimous approve with no
must-fix and explicitly praised the loose guards as "compatibility-first" and
"upgrade-safe," after which the maintainer filed a run of reviews each tightening
more guards — 4725911405, 4726462863, **4726472818 (this one: `M.any()` returns →
precise)**, 4726532241, 4726535732. The signal is identical to the cluster
pattern: the central artifact of the change (the interface guards) was
systematically under-specified against known static types, and no code-panel seat
carried the "does each guard match its known static type as tightly as possible?"
lens, so the panel affirmed the looseness rather than flagging it.

This review's specific slice — return guards, `returns(M.any())` where the static
return type is precisely known — is the same structural gap as the argument-guard
looseness in 396a141c, differing only in which position of the guard is loose. It
is therefore a member of `exo-guard-matches-static-type`, not a distinct pattern.

## Why a miss and not new direction

Nothing in this review states a new requirement, a scope change, or a matter of
taste. It applies the repo's own documented `CONTRIBUTING` § TypedPatterns
convention (guards are the runtime enforcement; static types are advisory; each
guard should match its static type as tightly as possible, looseness a documented
exception) to a guard the panel had every relevant seat to scrutinize and passed.
That is a review miss on an existing, documented convention, not anticipation of
something unforeseeable.
