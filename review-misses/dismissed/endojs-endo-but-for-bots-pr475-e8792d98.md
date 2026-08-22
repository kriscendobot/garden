---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr475-e8792d98
verdict: not-a-miss
category: new-direction
review_at: 2026-08-19T21:13:46Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-5348069925
identity: endojs/endo-but-for-bots#475:comment:5348069925
---

Directive comment on PR #475 (narrow byteArray to Uint8, cross-package immutable
byte-array work). The maintainer quotes the bot's own offer ("Happy to spec that
if you agree it's worth the cross-package churn") and answers: yes, please write
the spec, and after reading it I'll decide whether we should actually do the
change. The ask is for a brand-new specification/design deliverable — the
provider-side genuine-vs-emulated ArrayBuffer predicate exported by
`@endo/immutable-arraybuffer` — explicitly gated on the maintainer reading it
before any implementation is committed.

Grounds: this is a first-stated request for new design work, not an indictment of
#475's review process. Nothing existing is asserted wrong; the maintainer accepts
the bot's offer to spec a proposed cross-package refactor and reserves the
go/no-go for after reading. No seat brief, skill, standing instruction, or gate
could have anticipated a maintainer requesting a fresh spec mid-conversation —
this is textbook new direction (taste/scope first stated in the comment itself),
not a missed bug, spec violation, edge case, or convention. There is no
evaluator-gaming shape: the comment is a request that work be *created*, so no
evaluator was routed around or satisfied-in-letter-only.

Deliverable confirmed to EXIST despite the primary's doom: the primary job
`endojs-endo-but-for-bots-pr475-e8792d98` requeue-exhausted (doomed, 5 cycles) and
sits parked in jobs/plan/ having never completed — but the requested spec was
nonetheless delivered on the PR. The maintainer's later "what are all outstanding
requests" audit (comment 5348941386) surfaced the two silently-stalled jobs, which
were re-posted, and the spec landed as comment 5349227927 ("here is the spec, as
requested, for a provider-side genuine-vs-emulated predicate exported by
`@endo/immutable-arraybuffer`. Nothing here is implemented yet; this is the
contract for you to read and decide on"). So the directive was ultimately
satisfied, not falsely claimed. The original job's silent requeue-exhaustion is a
machinery-reliability signal (jobs stalling without reporting back) that belongs to
the mentor loop, not a review-process miss — out of the prosecutor's scope here.
