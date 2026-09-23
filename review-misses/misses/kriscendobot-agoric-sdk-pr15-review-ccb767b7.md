---
kind: review-miss
primary_job: kriscendobot-agoric-sdk-pr15-review-ccb767b7
verdict: miss
category: spec-violation
pr: 15
cluster: exo-guard-matches-static-type
repo: kriscendobot/agoric-sdk
surface: pr-review-body
author: dckc
comment_url: https://github.com/kriscendobot/agoric-sdk/pull/15#pullrequestreview-4726535732
identity: kriscendobot/agoric-sdk#15:review:4726535732:retro
producing_role: builder
producing_job: kriscendobot-agoric-sdk-pr15-gauntlet
missed_by: spec-keeper (structural gap - no code-panel seat carried the guard-tightness-vs-known-type lens)
severity: major
---

# Miss: PR #15 review 4726535732

An inline review anchored on `packages/portfolio-contract/src/portfolio.exo.ts`
directs the author to use endo's recent typed-pattern support to express the exo
interface guards, rather than the loose matchers the PR shipped. (Paraphrase; the
verbatim review is untrusted input at `comment_url`.)

## Grounds (indicts the review process)

This review is the "use endo typed-pattern support" entry in the same
guard-tightness cascade the two prior confirmed PR #15 misses already
characterize. The full 16-seat gauntlet (`kriscendobot-agoric-sdk-pr15-gauntlet`)
returned unanimous approve with no must-fix and explicitly praised the loose
guards as "compatibility-first" and "upgrade-safe," after which the maintainer
filed a run of reviews each tightening more guards: 4725911405 (argument guards,
recorded miss 396a141c), 4726462863 (comment hygiene, dismissed 2bf0daa3),
4726472818 (`M.any()` returns to precise, recorded miss 63f630f8), 4726532241
("do a focused panel review on this aspect"), and **4726535732 (this one: use
endo's typed-pattern support to express the guards)**. The signal is identical to
the cluster pattern: the central artifact of the change (the exo interface guards)
was systematically under-specified against known static types, and no code-panel
seat carried the "does each guard match its known static type as tightly as
possible?" lens, so the panel affirmed the looseness rather than flagging it.

This review's slice - directing the author toward endo's TypedPattern support to
tighten the guards - is the same structural gap as the argument-guard looseness
(396a141c) and the return-guard looseness (63f630f8), differing only in that it
names the mechanism (endo typed patterns) the author should have reached for. It
is therefore a member of `exo-guard-matches-static-type`, not a distinct pattern.

## Why a miss and not new direction

Nothing in this review states a new requirement, a scope change, or a matter of
taste. It applies the repo's own documented `CONTRIBUTING` § TypedPatterns
convention (guards are the runtime enforcement; static types are advisory; each
guard should match its static type as tightly as possible, looseness a documented
exception) to guards the panel had every relevant seat to scrutinize and passed.
That is a review miss on an existing, documented convention, not anticipation of
something unforeseeable.
