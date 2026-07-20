---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr794-review-cdf94916
verdict: not-a-miss
category: new-direction
pr: 794
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/794#pullrequestreview-4730172707
identity: endojs/endo-but-for-bots#794:review:4730172707:retro
producing_role: designer-then-review-follow-up
severity: minor
grounds: >
  PR #794 is a DESIGN-DOCUMENT PR (title "design(ocapn-noise): key-only session
  boundary"; the only touched artifact is
  designs/ocapn-noise-key-only-session-boundary.md and its designs/README.md
  summary rows; base llm, now MERGED at 00a04f5b). Review 4730172707 by kriskowal
  (the repo owner/maintainer) is state APPROVED with an EMPTY body and a single
  inline comment on the design document. That comment is pure ARCHITECTURAL
  DIRECTION refining the dependency/coupling topology of his own unbuilt design:
  OCapN should depend on NEITHER the network layer nor the relay; an application
  injects a network layer (e.g. Noise protocol over a web socket); the relay
  depends on nothing; and the Node exo controller is likewise loosely coupled,
  interacting with the relay only through configuration and a SIGHUP reload. This
  retro judges whether the garden REVIEW PROCESS should have anticipated this and
  concludes it could not have, for the same dispositive structural reason as the
  sibling dismissal on this PR (review 4729356746 / job pr794-review-a34bb7b7):
  these are first-stated requirements expressing the maintainer's own design taste
  and scope for a not-yet-implemented protocol boundary. No garden review surface
  encodes an opinion on the correct dependency direction between OCapN, a network
  layer, and a dumb relay, nor on how loosely the Node exo controller should couple
  to the relay — no seat brief, panel-hints probe, pre-push gate, or COMMON.md norm
  governs the architecture of an unbuilt design. There was correctly NO code
  panel/gauntlet on this PR: the panel is a code-review surface and #794 ships a
  document, not code, so no "panel should have run" process miss applies either.
  The PR history confirms the garden acted correctly: the primary job
  (pr794-review-cdf94916) addressed the feedback in commit 1f2654f99, replied
  inline, posted a summary, saw all 24 checks pass, and dispatched the conductor
  that un-drafted and merged the PR (merge commit 00a04f5b). Same class as the
  prior maintainer design-direction dismissal on this very PR — a maintainer
  refining the direction of his own design, unanticipatable by definition.
  Recorded as a durable dismissal so the same review is never re-litigated. No
  cluster minted; no improvement dispatched.
---

# Dismissal: endo-but-for-bots #794 review 4730172707 (retro)

PR #794 is a design-document PR (design(ocapn-noise): key-only session boundary).
kriskowal, the repo owner, left an APPROVED review with an empty body and one
inline comment on the design giving architectural direction on his own design:
OCapN should depend on neither the network layer nor the relay; an application
injects a network layer (like Noise protocol over a web socket); the relay depends
on nothing; and the Node exo controller stays loosely coupled, driven only by
configuration plus a SIGHUP reload.

Not a garden review-process miss. This is new direction: first-stated
requirements expressing the maintainer's taste and scope for an unbuilt protocol
boundary. No seat brief, probe, gate, or standing norm encodes the correct
dependency direction between OCapN, a network layer, and a dumb relay, nor how
loosely the Node exo controller should couple — nothing a review surface could
have caught ahead of the maintainer. Correctly no code panel ran (a design
document is not code). The primary job (pr794-review-cdf94916) adopted the
direction in commit 1f2654f99, all 24 checks passed, and the conductor merged the
PR (00a04f5b). Same class as the sibling dismissal on this PR (review 4729356746).
See comment_url for the verbatim review.
