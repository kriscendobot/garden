---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr1072-review-73226ec0
verdict: not-a-miss
category: new-direction
pr: 1072
repo: endojs/endo-but-for-bots
identity: endojs/endo-but-for-bots#1072:review:5047681541
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1072#pullrequestreview-5047681541
review_at: 2026-08-28T03:28:33Z
severity: minor
grounds: |
  Design steering on a wire-format grammar, first stated in the comment. PR
  #1072 is a draft that iterates the OCapN-Noise connection-hint locator design
  (designs/ocapn-noise-network.md) directly through maintainer review. In this
  review the maintainer showed, via a GitHub suggestion, the locator hint format
  he wants: one hint per composite <transport>+<codec> key (wss/ws/tcp x
  cbor/syrup) with a bare <host>:<port> value. That pivots the PR's own
  <scheme>:url=<scheme>://host:port direction and introduces a new CODEC
  dimension the design did not previously carry. No juror seat, skill, or
  standing instruction encodes a preferred OCapN locator grammar — that grammar
  IS the design being decided here, so nobody could have anticipated the codec
  dimension before the maintainer named it. This is taste/new-direction, not a
  bug, spec violation, missed edge case, or violated convention.

  Not evaluator-gaming/avoidance: the manual-gauntlet-trigger regime runs no
  panel on a draft under active maintainer design review, and the maintainer is
  iterating WITH the author (the intended design-fork flow), not being routed
  around. The primary job (73226ec0) genuinely delivered — it revised the design
  doc to the composite grammar and posted a threaded reply (discussion comment
  3877762195); the world confirms the composite <transport>+<codec> grammar
  landed in the design doc on the PR head (later reviews evolved the exact syntax
  from the query-string `=` form to `@`-delimited path components, normal design
  iteration). No no-op-that-never-happened discrepancy to report.
---

Maintainer review 5047681541 (CHANGES_REQUESTED, empty body, one inline
suggestion on the design doc) steers the OCapN-Noise locator toward a composite
`<transport>+<codec>` hint grammar with a new codec dimension. This is design
direction on a wire format first expressed in the comment — a dismissal, not a
review-process miss. Re-fetch the verbatim suggestion at comment_url.
