---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr1392-review-8531f855
verdict: miss
category: process
pr: 1392
cluster: design-bespoke-mechanism-over-existing-path
review_at: 2026-10-22T06:38:47Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1392#pullrequestreview-5610163704
identity: endojs/endo-but-for-bots#1392:review:5610163704:retro
producing_role: builder
producing_job: ebfb-sturdyref-layer3-pass-style-20260930 (Parcel pivot 2026-10-14) + endojs-endo-but-for-bots-pr1392-gauntlet-fix-5
missed_by: decomplector fired (round 5) but its must-fix was declined by the gauntlet fixer as "a design change" and never escalated; earlier rounds' breaker/saboteur/locksmith-lens must-fixes (round 3, "enforce every descriptor invariant") pushed MORE shape validation; no seat cross-checked designs/parcel.md ("the brand check is the only recognition path")
severity: moderate
grounds: |
  Maintainer CHANGES_REQUESTED (paraphrase): Parcel recognition in
  packages/pass-style/src/parcel.js is a shape check, deceivable by an
  equivalent shape; it should be a brand check, an object test plus a lookup
  in the WeakMap that holds each parcel's internal slots (location, open hook).
  Not new direction: (1) the authoritative design on the PR's own base,
  designs/parcel.md, already says the location and hook live in a closely held
  WeakMap, that Parcel.isParcel consults it, and that "the brand check is the
  only recognition path"; the shim (packages/parcel/src/parcel-shim.js) already
  implements it, as the bot's own acknowledgment comment 6338883256 confirms.
  (2) The post-pivot gauntlet ran six panel rounds (2026-10-15..16, reviews
  5528711935..5541469987); rounds 3-4 raised must-fixes that hardened the
  global-Parcel shape validation (descriptor invariants, stateful/lying
  isParcel, reentrancy) rather than questioning it. (3) In round 5 the
  code-panel decomplector probe from improvement 7a88d0007c2 (2026-10-07)
  DID fire and named the bespoke validator as a must-fix, but fix-5 removed
  only the decisions cache and declined the rest as "a design change"; panel 6
  then failed to post (token 403) and the gauntlet halted with 20 unaddressed
  must-fixes, leaving the maintainer to raise it. So the sensing half of the
  prior improvement worked but late (after four hardening rounds), and neither
  the builder-side prevention (existing path before a new mechanism) nor the
  fixer bound. Deliverable verified in the world: head 5f9bc1533d carries
  4a034b968a fix(pass-style), recognition reduced to object check + captured
  Parcel.isParcel (WeakMap has), shape validation deleted, same-shape impostor
  test added; a layering question (should the WeakMap live in pass-style?)
  remains open to the maintainer on the PR.
---
Retro of kriskowal's CHANGES_REQUESTED review on #1392: pass-style Parcel
recognition was a bespoke shape validator over the ambient global where the
landed design and shim already supply a WeakMap brand check; panel rounds
hardened the validator, and when the decomplector finally flagged it the fixer
declined the must-fix as a design change.
