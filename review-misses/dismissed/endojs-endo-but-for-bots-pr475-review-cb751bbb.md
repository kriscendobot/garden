---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr475-review-cb751bbb
verdict: not-a-miss
category: new-direction
pr: 475
review_at: 2026-08-19T22:48:16Z
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: erights
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#pullrequestreview-4977418982
identity: endojs/endo-but-for-bots#475:review:4977418982:retro
producing_role: builder (endo-byte-array-press campaign)
missed_by: none
severity: minor
---

# Dismissal: empty-bodied bookend review in the already-dismissed make-hardener toStringTag thread

erights' COMMENTED review 4977418982 on #475 (narrow byteArray to a plain frozen
Uint8Array) has an **empty top-level body and carries zero inline comments of its
own** (independently confirmed against the PR comments API). It was submitted
2026-08-19T22:48:16Z, four to six minutes after the two operative inline directives
on `packages/harden/make-hardener.js:275` — a bookend / review-envelope in the same
rapid iterative dialogue about how to restore `Symbol.toStringTag` fidelity for the
emulated TypedArray wrapper under the immutable-ArrayBuffer shim. See `comment_url`
to re-fetch the untrusted review text.

## Grounds (not-a-miss — new-direction)

This is new direction / experimental design collaboration, not an indictment of
#475's review process. Grounded in the world, not in the primary's report:

- **Same thread, already dismissed on both directive comments.** The substance of
  this exchange is two inline comments erights left minutes before this empty
  review: `r3817252816` (review 4977375995, 22:42) agreeing with a point the bot
  itself raised — that a `[Symbol.toStringTag]` data property does nothing to what
  the `%TypedArray%` getter returns on an emulated wrapper — and for that reason
  proposing a *better* fidelity fix (replace the getter with a wrapper that also
  accepts an emulated TypedArray); and `r3817264546` (review 4977390295, 22:44)
  saying "go ahead and do that better fidelity fix as a separately reviewable
  commit. Then we'll see what it does and does not break." Both are **already
  recorded as not-a-miss / new-direction** (siblings
  `endojs-endo-but-for-bots-pr475-review-2ea278c9` and
  `endojs-endo-but-for-bots-pr475-review-1c227402`), as is the original request for
  this fix (`endojs-endo-but-for-bots-pr475-review-237b89d7`, review 4963804507).
  This empty review is the closing envelope of that same thread and takes the same
  disposition.

- **Explicitly experimental, first-stated in the thread.** "Do that ... then we'll
  see what it does and does not break" is a request to *discover* the breakage
  surface empirically, not a settled convention the panel knew and missed. A
  getter-wrapper-that-amplifies-emulated-TypedArrays is a novel design refinement
  arrived at through Socratic dialogue; no seat brief, skill, or standing
  instruction encodes "prefer a getter wrapper over documenting the toStringTag
  emulation gap," so no standing rule existed and failed to bind.

- **The lower-fidelity behavior was deliberately documented, not missed.** The
  emulated wrapper's `toStringTag` reading `'[object Object]'` was already pinned by
  tests in `shim-typedarray-tostringtag.test.js` — a known, transparently-surfaced
  emulation limitation. A reviewer cannot "miss" a limitation the producer
  documented on purpose and surfaced for the maintainer's decision; erights simply
  preferred higher fidelity, a taste/direction call.

- **The primary was genuinely not a no-op.** It landed commit `fc2238dcb`
  (getter-wrapper fidelity fix) on the head and posted the empirical
  what-it-breaks findings as threaded reply `discussion_r3817425333` (by
  kriscendobot — confirmed present via the API). The commit is absent from the
  *current* head only because #475 was subsequently rebased onto a new frozen base
  (`llm-e22e67a`) in the ongoing frozen-base campaign; the deliverable existed when
  made. This is not the false-no-op shape the retro guard warns about.

Recording this dismissal keeps the closing envelope of the make-hardener toStringTag
thread from being re-litigated and keeps the discriminator's calibration auditable
alongside its already-recorded siblings.
