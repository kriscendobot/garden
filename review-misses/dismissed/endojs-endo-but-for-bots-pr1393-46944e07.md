---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr1393-46944e07
verdict: not-a-miss
category: new-direction
pr: 1393
repo: endojs/endo-but-for-bots
identity: endojs/endo-but-for-bots#1393:comment:4352299587:retro
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1393#discussion_r4352299587
review_at: 2026-10-22T18:55:27Z
severity: minor
grounds: |
  The comment, on packages/marshal/src/marshal-justin.js where the @import
  path moved from ./types.js to ./types.types.js, is a research directive,
  not an indictment of a known rule. The maintainer (kriskowal) says the
  packages show several precedents for hand-written type definitions, asks
  the bot to survey current Endo and Agoric SDK guidance (weighting named
  maintainers), write an IBIS as a new issue, and adopt its recommendation
  on the PR, with a later normalization follow-up. He states that the
  convention is unsettled. A requirement the maintainer is only now setting
  out to decide could not have been enforced by any seat.

  The garden's standing rule (typist seat, builder directive, and the
  typedefs-belong-in-dts gate from cluster typedef-location-dts) covers only
  typedefs in .js files. It requires a .d.ts/.ts types module and does not
  say which of those shapes or file names to use. The PR followed that rule,
  so no rule failed to bind. The review process ran: the
  ebfb-sturdyref-layer4-marshal-20260930 gauntlet (clean, viability,
  panels 1-6, fixes 1-6) is in journal/jobs/tada/. This is not avoidance or
  evaluator-gaming.

  World check: the primary routed the directive to job
  endo-handwritten-types-ibis (tada 2026-10-22). Issue #1540, "IBIS: Where
  should hand-written type definitions live?", exists with that job's marker.
  The recommendation (type-only .ts canonical definitions plus
  declaration-only .d.ts entrypoints) matches PR head 2a40caf714 (src/types.ts).
  The deliverable exists, so the primary did not close as a false no-op.
---
Dismissed: the maintainer said the repository has no settled convention for
hand-written type definitions and asked for an IBIS issue to decide one, with
the PR adopting its recommendation. This requirement was first stated in the
comment. The existing .d.ts/.ts rule was followed, and the IBIS (#1540) and
PR adoption were delivered.
