---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr288-review-330391eb
verdict: not-a-miss
category: new-direction
pr: 288
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/288#pullrequestreview-4629027865
identity: endojs/endo-but-for-bots#288:review:4629027865:retro
producing_role: none-garden-did-not-author-or-panel-review
severity: minor
grounds: >
  kriskowal's CHANGES_REQUESTED review on the @endo/cbor-frame PR carried three
  asks (paraphrased): (1) hand the package to a Fable agent for a closer review;
  (2) factor the package's local byte-concatenation onto the shared
  @endo/bytes/concat.js module; (3) the local materialize() optimizations
  should presumably live inside that shared module. This retro judges whether
  the garden REVIEW PROCESS should have anticipated these, and concludes it
  could not have. The dispositive fact from the PR's actual history: the garden
  fleet never authored or review-owned this package. The journal shows only
  branch-ops and routing jobs for #288 (endojs-endo-but-for-bots-pr288-refresh,
  -shepherd, and the -review-330391eb routing job) plus the Fable pass those
  asks spawned (ebfb-pr288-fable-review / -post); there is NO build, gauntlet,
  panel, clean, judge, or fixer job for cbor-frame anywhere on the board. The
  package originated outside the fleet, so no garden panel or seat ever reviewed
  its design — there is no review surface that demonstrably knew a convention
  and failed to bind. Ask (1) is a maintainer process directive (electing to
  invoke a second AI review), which is unanticipatable by definition. Asks (2)
  and (3) are exploratory reuse/design suggestions whose own framing signals
  recency and uncertainty ("Now provided by ...", "presumably ..."), and the
  Fable review the maintainer's own directive requested went on to find ask (3)
  partly INCORRECT: the single-chunk zero-copy short-circuit must NOT move into
  the shared concatBytes because it would weaken that module's fresh-copy /
  no-aliasing contract that existing consumers rely on. A review-cycle check
  that had fired "must factor all of this onto @endo/bytes/concat.js" would thus
  have produced a partially wrong finding. This is maintainer-first review of
  externally-authored work plus a design discussion, i.e. new direction — not a
  garden review-process miss. Recorded as a durable dismissal so the same
  comment is never re-litigated. No cluster minted; no improvement dispatched.
---

# Dismissal: endo-but-for-bots #288 review 4629027865 (retro)

The @endo/cbor-frame CHANGES_REQUESTED review asked for a Fable second-pass and
for the package's local byte-concat / materialize optimizations to be factored
onto the shared @endo/bytes/concat.js module. Not a garden review-process miss:
the fleet never authored or panel-reviewed this package (only refresh, shepherd,
and routing jobs exist for #288), so no seat demonstrably knew a convention and
failed to bind. The Fable review the maintainer requested even found the "move
the optimizations into the shared module" ask partly wrong (the zero-copy
short-circuit must stay at the call site to preserve concatBytes's no-aliasing
contract). Maintainer-first review of externally-authored work plus a live
design discussion — new direction, not a miss. See comment_url for the verbatim
review.
