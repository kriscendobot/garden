---
kind: result
role: gardener
host: endolinbot
at: 2026-07-05T22:07:01Z
---
# result — prosecutor retro on endojs/endo-but-for-bots #288 (review 4629027865)

**Role:** prosecutor (review-retrospective second loop).
**Primary:** endojs-endo-but-for-bots-pr288-review-330391eb (unchanged; the review
feedback is addressed there and by the ebfb-pr288-fable-review chain).

**Verdict: NOT-A-MISS (new-direction).** Recorded as a durable dismissal:
review-misses/dismissed/endojs-endo-but-for-bots-pr288-review-330391eb.md. No
cluster minted, no threshold evaluated, no improvement job dispatched.

**Grounds (from the PR's actual history, not the comment text).** kriskowal's
CHANGES_REQUESTED review carried three asks: (1) hand @endo/cbor-frame to a Fable
agent for a closer review; (2) factor the package's local byte-concat onto the
shared @endo/bytes/concat.js; (3) the local materialize() optimizations should
presumably live inside that shared module. The garden fleet never authored or
review-owned this package — the board shows only branch-ops and routing for #288
(refresh, shepherd, the review-routing job) plus the Fable pass those asks
spawned; there is NO build/gauntlet/panel/clean/judge/fixer job for cbor-frame
anywhere. With no garden panel or seat having reviewed the package, there is no
review surface that demonstrably knew a convention and failed to bind. Ask (1) is
an unanticipatable maintainer process directive (electing a second AI pass). Asks
(2)/(3) are exploratory reuse suggestions ("Now provided by...", "presumably..."),
and the Fable review the maintainer requested found ask (3) partly INCORRECT — the
single-chunk zero-copy short-circuit must NOT move into concatBytes or it weakens
that module's no-aliasing contract. A review-cycle check firing "must factor onto
@endo/bytes/concat.js" would have produced a partially wrong finding. This is
maintainer-first review of externally-authored work plus a live design discussion.

**No garden-library change.** A dismissal is record-and-complete; nothing to
commit to main2.

Self-improvement: none this engagement — the discriminator resolved cleanly on the
board's job history alone (absence of any build/panel job for the package was
dispositive), which is exactly the grounding the skill prescribes over the comment
text. No friction to encode.
