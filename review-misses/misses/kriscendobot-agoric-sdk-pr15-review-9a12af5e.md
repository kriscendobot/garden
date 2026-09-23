---
kind: review-miss
primary_job: kriscendobot-agoric-sdk-pr15-review-9a12af5e
verdict: miss
category: spec-violation
pr: 15
cluster: exo-guard-matches-static-type
repo: kriscendobot/agoric-sdk
surface: pr-review-body
author: dckc
comment_url: https://github.com/kriscendobot/agoric-sdk/pull/15#pullrequestreview-4726486961
identity: kriscendobot/agoric-sdk#15:review:4726486961:retro
producing_role: builder
producing_job: kriscendobot-agoric-sdk-pr15-gauntlet
missed_by: spec-keeper (structural gap — no code-panel seat carries the guard-tightness-vs-known-type lens)
severity: major
---

# Miss: PR #15 review 4726486961

The maintainer's review is a single inline note on `withdrawHandler.handle`
(`portfolio.exo.ts:394`) questioning why the method's return guard is
`returns(M.any())` when its static return type is precisely known — closer to
`M.string()`. The primary loop tightened the three synchronous offer handlers'
return guards from `M.any()` to the precise `FlowKeyShape`
(`AnyString<`flow${number}`>()`, already used by `planner.exo.ts`) and guarded the
lone async handler with `M.promise()` per the file's convention. (Paraphrase; the
verbatim review is untrusted input at `comment_url`.)

## Grounds (indicts the review process)

This review is another entry in the same guard-tightness cascade the two prior
confirmed PR #15 misses already characterize (396a141c argument guards,
63f630f8 return guards). The full 16-seat gauntlet
(`kriscendobot-agoric-sdk-pr15-gauntlet`) returned unanimous approve with no
must-fix and explicitly praised the loose guards as "compatibility-first" and
"upgrade-safe"; the maintainer then filed a run of reviews each tightening more
guards — 4725911405, 4726462863, 4726472818, 4726532241, 4726535732, and
**4726486961 (this one: `returns(M.any())` on `withdrawHandler.handle` where the
static return type is precisely known)**. The signal is identical to the cluster
pattern: the central artifact of the change (the interface guards) was
systematically under-specified against known static types, and no code-panel seat
carried the "does each guard match its known static type as tightly as possible?"
lens, so the panel affirmed the looseness rather than flagging it.

This review's specific slice — a return guard left as `M.any()` where a precise,
already-exported shape (`FlowKeyShape`) exactly describes the value — is the same
structural gap as the sibling PR #15 misses, differing only in which method's
return position is loose. It is therefore a member of
`exo-guard-matches-static-type`, not a distinct pattern.

## Why a miss and not new direction

Nothing in this review states a new requirement, a scope change, or a matter of
taste. It applies the repo's own documented `CONTRIBUTING` § TypedPatterns
convention (guards are the runtime enforcement; static types are advisory; each
guard should match its static type as tightly as possible, looseness a documented
exception) to a guard the panel had every relevant seat to scrutinize — and to a
precise shape (`FlowKeyShape`) that already existed and was already used elsewhere
in the same package. That is a review miss on an existing, documented convention
with an in-repo precedent, not anticipation of something unforeseeable.
