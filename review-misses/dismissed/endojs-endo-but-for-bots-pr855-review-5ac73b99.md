---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr855-review-5ac73b99
verdict: not-a-miss
category: new-direction
review_at: 2026-09-04T05:01:52Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/855#pullrequestreview-5109336109
identity: endojs/endo-but-for-bots#855:review:5109336109:retro
---

Design-stage review (CHANGES_REQUESTED, body "rsvp") on the draft design doc
`designs/endor-packaging.md`, carrying three inline maintainer decisions, all
new-direction: (1) reverse the design's own prior stance and accept C
dependencies as permanent rather than sink energy into a pure-Rust cross
end-state; (2) "Check" — verify the forward-looking Windows XS build claim;
(3) "Agreed" — endorse the build-provenance-attestation provenance baseline.

Grounds: none of the three is a bug, spec violation, missed edge case, or a
violated convention any panel seat demonstrably knows. All three are maintainer
architecture/direction calls on a not-yet-built system — reversing a design's
own direction, prompting a fact-check, and ratifying a proposed baseline — the
kind of taste/scope decision no review seat is positioned to pre-empt. Not
evaluator-gaming/avoidance either: a gauntlet WAS staged for this PR
(endojs-endo-but-for-bots-pr855-gauntlet + -gauntlet-clean in journal/jobs/tada/)
and halted mechanically at the clean stage because the docs-only PR is
CONFLICTING against base `llm`, reporting the halt loudly rather than routing
around the evaluator. The primary
(endojs-endo-but-for-bots-pr855-review-5ac73b99) did genuine work — commit
4f17d684ae edits designs/endor-packaging.md and is the current PR head — so the
directives deliverable exists; this is not a false-peer no-op. Consistent with
the prior dismissal on this same design PR
(endojs-endo-but-for-bots-pr855-df7988e4, also new-direction sequencing).
