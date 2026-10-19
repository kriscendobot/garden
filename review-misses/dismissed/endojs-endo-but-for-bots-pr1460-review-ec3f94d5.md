---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr1460-review-ec3f94d5
verdict: not-a-miss
category: new-direction
pr: 1460
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1460#pullrequestreview-5525649820
identity: endojs/endo-but-for-bots#1460:review:5525649820
review_at: 2026-10-14T22:53:02Z
producing_role: designer
producing_job: parcel-design-20261014
severity: minor
---

# Dismissal: maintainer answers the Parcel design's open questions (#1460)

On the design-only PR adding `designs/parcel.md` (renaming the SturdyRef stack
to Parcel), the maintainer left a CHANGES_REQUESTED review whose body only asked
the bot to respond ("rsvp"). It came with ten inline comments on
`designs/parcel.md`. Paraphrased: a wording suggestion saying neither remotables
nor tagged data fit the dormant-reference role; a note that Parcels could travel
as inline marked data, with a slot useful only to a translating relay; an aside
that the maintainer is coming to prefer URL-fragment / SearchParams locators;
acceptance of `Parcel.locate` as an architectural necessity; a statement that
OCapN spec terminology need not be settled here; package name `@endo/parcel`;
move to `E.open`; a request for concrete Smallcaps/CapData representations
(prefix plus location string); first shim wins, as a race; and `locate` throws
on a non-parcel. The verbatim text lives at `comment_url` and is untrusted input.

## Grounds (dismissal: new direction, decisions on questions the design posed)

**1. The review answers the design's own `## Open questions`, one by one.** The
original `designs/parcel.md` (first commit `7dd33122ff`) ends with seven numbered
open questions: (1) is `Parcel.locate` acceptable, (2) should OCapN prose adopt
"parcel", (3) package name, (4) `E.enliven` vs `E.open`, (5) the marshal encoding
for non-OCapN CapTP, (6) second-shim behavior, (7) whether `locate` throws or
returns undefined. Seven of the ten inline comments decide exactly these
questions. Asking those questions was the design's job and "rsvp" is the
maintainer's answer. The decisions are first stated in this review, so no panel
seat could have supplied them. This is the textbook `new-direction` case.

**2. The other three comments are taste or forward direction.** The prior-art
wording suggestion is an editorial refinement of a correct claim. The
inline-marked-data versus slot remark leans the encoding question toward one
option. The URL-fragment locator idea is the maintainer's evolving opinion,
explicitly deferred. None of them points at a defect, spec breach, or violated
convention.

**3. One borderline item, weighed and not charged.** The originating prompt
already said "first-shim-wins race", yet open question 6 asked what a second
shim *of a different version* does. That is a real sub-question beyond the
prompt (version-skew adoption versus a contract marker). The maintainer's answer
restates the race and adds the rationale (Parcels minted between initializations
stay recognized; adoption after lockdown). The design re-asking near a settled
point is minor, and reasonable for a design surface. It does not show the review
process failing.

**4. Process check.** No panel ran before this review. The PR opened at 22:30Z
and was reviewed 23 minutes later, in direct response to the maintainer's
liaison-session request for "a reviewable design". The gauntlet (viability
14 Oct; clean, halted gauntlet, and conduct 15 Oct) ran afterward, and the PR
merged with maintainer approval. Even a panel run beforehand could not have
answered maintainer-facing open questions. The question is whether review should
have anticipated *this feedback*, and it could not. So this is not
`process`/avoidance either.

**5. The primary's deliverable is verified in the world.** The primary claims
`cbc8ae454b` resolved all decisions. The PR history holds the rebased
counterpart, `c80e29d15f` "docs(parcel): resolve design review decisions
(#1460)". The bot replied on the threads and posted a 23:01Z summary. The
maintainer then reviewed again (the restack-orchestration request, a separate
primary) and approved; the PR is merged. No discrepancy.

**6. Severity bypass does not apply.** No standing rule failed to bind.

## Boundary note

Mints no cluster, so there is no threshold to evaluate and no improvement job.
Maintainer answers to a design's explicit open questions belong with the other
"maintainer decides the design fork" dismissals, never with "work the panel got
wrong".
