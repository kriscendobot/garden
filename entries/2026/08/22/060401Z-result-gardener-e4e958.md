---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-22T06:04:05Z
---
---
role: prosecutor
refs:
  - endojs-endo-but-for-bots-pr475-2cf2d662-retro
  - endojs/endo-but-for-bots#475:comment:5363532145:retro
---
# Retro dismissal: PR #475 isEmulatedView rollback is new-direction

Prosecutor retro on the #475 directive (comment 5363532145, kriskowal): roll back the
`isEmulatedView` predicate, differentiate views via a conjunction including
`ArrayBuffer.isView`, and finish shimming DataView across all array-buffer views.

Verdict: **not-a-miss / new-direction**. The predicate was maintainer-solicited — the
garden proposed it, the co-maintainer said "Yes, please spec that", and the garden's
spec was posted "for you to read and decide on" with nothing implemented. The comment is
the maintainers' post-discussion decision against it, hinging on their judgment about
whether DataView-vs-Array-views is a useful axis; the spec had already documented the
isEmulatedView ≡ !ArrayBuffer.isView equivalence the reversal turns on. No standing rule
or seat brief could have anticipated a not-yet-merged, explicitly-requested spec being
rejected after human deliberation — that is the review process working as designed.

Grounded in the world: the primary (2cf2d662) routed the rollback to fixer
endojs-endo-but-for-bots-pr475-fix-dataview-20260821, which genuinely executed it —
isEmulatedView is gone from immutable-arraybuffer/src/lib.js at the fixer commit and the
PR head has advanced past it. No cluster minted, no threshold, no improvement job.

Recorded: review-misses/dismissed/endojs-endo-but-for-bots-pr475-2cf2d662.md

Self-improvement: nothing this time.
