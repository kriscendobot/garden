---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr475-review-1c227402
verdict: not-a-miss
category: new-direction
review_at: 2026-08-19T22:44:34Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#pullrequestreview-4977390295
identity: endojs/endo-but-for-bots#475:review:4977390295:retro
---

Directive review on PR #475 (narrow byteArray to a plain frozen Uint8Array). The review
carries an empty top-level body; its substance is a single inline comment on
`packages/harden/make-hardener.js` line 275. In it the maintainer (erights), mid-thread on
how to restore `Symbol.toStringTag` fidelity under the immutable-ArrayBuffer shim, tells the
bot to stop iterating in the abstract and just land the better-fidelity fix as a separately
reviewable commit so that its concrete breakage surface can be observed — an explicitly
experimental "do it and we'll see what it does and does not break" step.

Grounds: this is new direction, not an indictment of #475's review process. The comment is a
maintainer steering an exploration whose outcome the maintainer himself does not yet know
("we'll see what it does and does not break") — the defining shape of a first-stated,
unanticipatable directive. It is not a bug, a spec/style violation, a missed edge case, or a
violated convention that any seat brief, skill, or standing instruction encodes; no panel
lens could have pre-empted a "land the trial fix as its own commit so we can measure the
fallout" instruction, because there is no correct-answer to catch — the whole point is to
generate the evidence. It sits inside an active, deeply-reviewed thread (kriskowal's
2026-08-18 review 4963804507 first asked for a separately reviewable toStringTag-getter fix;
erights' 2026-08-19 review 4976183942 then probed why prior cleanup passes had not committed
fully to `ArrayBuffer.isView`), so the review machinery plainly ran and is collaborating on
direction, not being routed around.

No evaluator-gaming shape: #475 is a live, heavily-reviewed PR — `journal/jobs/tada/` holds
dozens of review/gauntlet jobs for it — so no evaluator was skipped or met in letter-only
fashion.

Note distinguishing this from a nearby genuine miss: the *incomplete conversion* concern in
the sibling thread (erights review 4976183942 — occurrences of `isTypedArray` /
`getTypedArrayToStringTag` left on the toStringTag getter instead of `ArrayBuffer.isView`)
rhymes with the already-recorded `incomplete-sibling-transformation` cluster (miss
pr475-9885f3d8). But that is a *different* review; the target review 4977390295 is not "you
missed converting the siblings" — it is "go ahead and try the fidelity fix as a discrete
commit." The former is a review-miss (already captured); the latter is exploratory
direction. Keeping them distinct is the point of recording this verdict rather than
absorbing the target into the sibling cluster.

Verified against the world, not the primary report: the primary job
(`endojs-endo-but-for-bots-pr475-review-1c227402`) has NOT run — it is still parked in
`jobs/plan/`, so no primary deliverable exists yet and this retro's verdict rests only on the
fetched PR review history, not on any primary claim. This dismissal therefore neither relies
on nor contradicts a primary resolution; it is grounded directly in the review thread.
