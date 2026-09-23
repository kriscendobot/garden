---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr475-review-07347c0d
verdict: not-a-miss
category: new-direction
review_at: 2026-08-18T19:56:54Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#pullrequestreview-4965211312
identity: endojs/endo-but-for-bots#475:review:4965211312:retro
---

Review (COMMENTED, empty top-level body) by erights on PR #475, carrying a single
inline reply on `packages/pass-style/src/concat-bytes.js`. The reviewer quotes a
parenthetical the bot had written in a June review-thread reply — that
`Uint8Array.prototype.set`'s native fast path "would otherwise read zeros from
the immutable backing buffer" — and asks the bot to explain it, whether later
commits have obsoleted it, and whether the intended axis was
genuine-vs-emulated rather than mutable-vs-immutable. The bot answered
(reply 3809967108): yes on both — the zero-read hazard is specific to an
*emulated* non-view (`ArrayBuffer.isView === false`), not to immutability
(reads from an immutable buffer are always permitted); and the comment is
obsolete because the module was deleted in a consolidation and the surviving
read helper (`@endo/bytes/src/concat.js`) now gates solely on
`ArrayBuffer.isView`.

Grounds: this is a clarifying thread question about the bot's own conversational
prose, resolved by concurrence — not an indictment of #475's review process.
Four grounded reasons. (1) The reviewed artifact is a GitHub review-thread
reply the bot wrote on 2026-06-22 (comment 3450826655), not code, a code
comment, or a repo doc. No code panel, gauntlet, or juror seat reviews the
accuracy of the bot's GitHub conversation prose; that is the same boundary that
placed the e3925eb5 thread-etiquette comment outside the prosecutor's scope
(machinery/interaction, not a work-product defect a seat is positioned to
catch). (2) It is a question, answered, with no live defect and no code change
requested: the reviewer himself asks "has this comment already been obsoleted by
later commits?", and it has — the `concat-bytes.js` module no longer exists on
the head tree and the surviving `toIndexableUint8` helper was independently
corrected to gate on `ArrayBuffer.isView` (commit 739cbc2e9), the last read
helper that still consulted `.buffer.immutable`. (3) The convention the reviewer
invokes — "genuine-vs-emulated via `ArrayBuffer.isView` is the canonical
discriminator, not mutable-vs-immutable" — was itself the *design output* of this
PR's own August maintainer conversation (accepted in 6c19a076 as "the one
committed fidelity loss", specced in e8792d98/spec-genuine-predicate,
operationalized across siblings in the incomplete-sibling-transformation
cluster). At the time the June prose was written that axis choice did not yet
exist as a standing rule; faulting a June comment for not matching an August
design conclusion is anachronistic, so there is no standing seat brief, skill,
or COMMON norm that existed and failed to bind. (4) The underlying June behavior
(gating a defensive copy on `.immutable === true`) was at most an over-broad copy
— a perf pessimization on native/stage-3 engines, not a correctness bug, since
reads from immutable buffers are always valid — and its correctness dimension is
already captured thematically by the isView-canonicalization arc recorded in the
`incomplete-sibling-transformation` (correctness-bug) cluster; recording it again
here would double-count that theme on the strength of thread prose rather than a
reviewable diff. No evaluator-gaming shape applies: nothing was routed around a
gate and no seat's measurable check was met while its purpose went unmet.

Verified against the world, not the primary report. The primary job
(endojs-endo-but-for-bots-pr475-review-07347c0d) did NOT close as a clean no-op:
it requeue-exhausted and was doomed by the reaper (doomed_at 2026-08-19T01:53:04Z,
doom_signature requeue-exhausted, 5 cycles) and now sits parked in jobs/plan/
under gate go-ahead, never having run. The directive was nonetheless satisfied by
a later, independent action on the PR: kriscendobot's answer reply 3809967108
(2026-08-19T04:06:06Z, ~2h after the doom; garden-provenance footer, garden
commit 745fa908) fully addresses every ask in the review — it explains the
parenthetical, confirms the genuine-vs-emulated axis, and confirms the comment is
obsolete with the consolidation/`isView` details. So the deliverable exists in
the world and the dismissal does not rest on an unverified peer no-op. The
primary's silent requeue-exhaustion is a machinery-reliability signal (a directive
job stalling without reporting back, the same pattern noted in the e8792d98
dismissal) that belongs to the mentor loop, not a review-process miss — out of
the prosecutor's scope here.
