---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr475-6c19a076
verdict: not-a-miss
category: new-direction
review_at: 2026-08-18T00:11:45Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-5321775351
identity: endojs/endo-but-for-bots#475:comment:5321775351
---

Directive comment on PR #475 (narrow byteArray to a plain frozen Uint8Array). The bot
had itself offered to land a byteArray.js brand-check refinement and, optionally, a
compare.js index-in-place rewrite; the maintainer replied "yes, do both" and asked that
all the prose be corrected so that `ArrayBuffer.isView` becomes the single fidelity loss
the design commits to (demoting the integer-indexed-read and toStringTag differences to
incidental consequences).

Grounds: this is new direction and maintainer taste, not an indictment of #475's review.
The comment accepts a proposal the bot originated in the thread and then makes a design
call — which of several observable fidelity differences the design will treat as a
*committed* loss versus an incidental one. That is a first-stated requirement in the
comment itself: nothing in a seat brief, skill, or standing instruction encodes which
fidelity losses this particular design should commit to, so no juror could have
anticipated it, and there is no bug, spec violation, missed edge case, or violated
convention to catch. Both the byteArray.js/compare.js code changes and the prose framing
are decisions the maintainer is steering here, not defects the panel let through. There
is no evaluator-gaming shape: #475 is a live, heavily-reviewed PR — journal/jobs/tada/
holds dozens of review/gauntlet jobs for it — so no evaluator was routed around or met in
letter-only fashion; the maintainer is collaborating on direction on a PR whose review
machinery plainly ran. Verified against the world, not the primary report: the primary
job (pr475-6c19a076) genuinely landed the work as PR-head commit 9b202d4554 (byteArray.js
two-shape check now discriminating on isView, compare.js zero-copy in-place indexing,
prose retitled to name isView as "the one committed fidelity loss", and new isView pins in
the shim and client test suites), so the directive was actually executed rather than
falsely claimed. Sibling directive-follow-ups from the same erights request were split
into pr475-fa8acb7f and pr475-e4629ae8 and resolved as no-ops once 9b202d4554 won the push.
