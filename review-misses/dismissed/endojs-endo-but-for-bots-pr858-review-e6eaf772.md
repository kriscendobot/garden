---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr858-review-e6eaf772
verdict: not-a-miss
category: new-direction
pr: 858
repo: endojs/endo-but-for-bots
identity: endojs/endo-but-for-bots#858:review:5056882428:retro
comment_url: https://github.com/endojs/endo-but-for-bots/pull/858#pullrequestreview-5056882428
review_at: 2026-08-29T04:25:06Z
severity: minor
grounds: |
  Naming taste first expressed in the comment. PR #858 adds a stream buffer
  abstraction to @endo/stream, originally exported as "buffer" and "unbounded
  buffer" across two subpaths. The maintainer's CHANGES_REQUESTED review is a
  naming brainstorm — asking for better names, proposing a scheme that reserves
  "ring buffer" for the future BOUNDED synchronous variant and "auto buffer" for
  the current unbounded auto-growing one. This is a preference to pick more
  evocative names AND to carve conceptual space for an unimplemented ring buffer;
  it is not a bug, spec violation, missed edge case, or violated convention.

  Not a naming MISS of the kind the corpus already holds. The existing `naming`
  clusters (semantic-name-matches-value-kind, name-contradicts-value-type) are
  about names that CONTRADICT or misrepresent the declared value — e.g. calling a
  Uint8Array `buffer`. Here the names were accurate: a buffer was named "buffer",
  an unbounded buffer "unbounded buffer" — clear, defensible names that lie about
  nothing. No juror seat brief (ergonomist, stylist), skill (rename-discipline),
  or standing instruction encodes a rule that a growing buffer must not be called
  "buffer", nor that a future bounded variant's conceptual space must be reserved
  in the name. Nobody could have anticipated the specific ring-buffer/auto-buffer
  scheme before the maintainer named it. Taste/new-direction, not a review miss.

  Not evaluator-gaming: no measurement moved. The rename was a direct response to
  the maintainer's stated preference, not a change shaped to satisfy a gate while
  leaving its purpose unmet; no gauntlet/panel was routed around (the review was a
  direct maintainer read, and the primary re-ran verification after the rename).

  World-checked, no no-op discrepancy. The primary (review-e6eaf772) genuinely
  delivered: it renamed the abstraction to `auto-buffer` (subpath
  @endo/stream/auto-buffer, factory makeAutoBuffer, types AutoBuffer*), collapsed
  the two former subpaths into one, and pushed commit c4b80833a. The maintainer
  then APPROVED at review 5122872506 (2026-09-05) and the PR MERGED as squash
  commit 2662950483 titled "feat(stream): add auto buffer". The rename landed and
  was accepted upstream; the deliverable exists.
---

Maintainer review 5056882428 (CHANGES_REQUESTED) on PR #858 is a naming
brainstorm: it asks for better names than "buffer" / "unbounded buffer" and
proposes reserving "ring buffer" for a future bounded variant and "auto buffer"
for the current unbounded one. The original names were accurate and violated no
standing naming convention; the preferred scheme — evocative names that carve out
space for an unimplemented bounded ring buffer — is design taste first stated in
the comment. A dismissal, not a review-process miss. The primary renamed to
`auto-buffer`, which the maintainer approved and merged. Re-fetch the verbatim
comment at comment_url.
