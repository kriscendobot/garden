---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr475-review-2ea278c9
verdict: not-a-miss
category: new-direction
pr: 475
review_at: 2026-08-19T22:42:46Z
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/475#discussion_r3817252816
identity: endojs/endo-but-for-bots#475:review:4977375995
producing_role: builder
missed_by: none (new direction, not a review-catchable defect)
severity: n/a
grounds: |
  This review (erights, review 4977375995, one inline comment on
  packages/harden/make-hardener.js:275) is a maintainer AGREEING with a point
  the bot itself had just raised, then proposing a stronger future fix. The bot
  had argued that installing a [Symbol.toStringTag] data property does nothing to
  what the %TypedArray% getter returns on an emulated wrapper. erights concedes
  that ("that is true") and, for exactly that reason, calls the data-property fix
  a flawed fidelity fix and suggests a better one: replace the
  %TypedArray%.prototype[Symbol.toStringTag] getter with a wrapper around the
  original that also accepts an emulated TypedArray, offered explicitly as a
  "separately reviewable commit."

  This is new direction, not a review miss. Discriminator test — should the
  panel have caught it? No: (1) the current diff is not defective — erights is
  affirming its reasoning; the code deliberately relies on the getter returning
  undefined on emulated wrappers, documented in the diff hunk itself. (2) The
  comment proposes NEW work (a getter-wrapper enhancement), a scope addition
  first stated in the thread, not a violation of any seat brief, skill, or
  standing rule the panel demonstrably knows. (3) It is a collaborative design
  refinement co-developed in an active dialogue the bot opened. No engine-realist
  or spec-keeper lens could be expected to pre-empt a maintainer's taste call on
  which of two fidelity strategies to pursue as a follow-up.

  Grounded in the world, not the primary report: the review body is empty (COMMENTED
  state, verified via gh api); the single inline comment 3817252816 is a reply to
  the bot's comment 3816913497. The primary did NOT close as a no-op — it posted a
  concession reply (comment 3817303168 by kriscendobot, verified present in the
  world) and handed the getter-wrapper implementation to peer review 4977390295
  (job endojs-endo-but-for-bots-pr475-review-1c227402). The implementation being
  owned elsewhere confirms this is forward design work, not a missed defect.

  Note for calibration: this PR's genuine review misses cluster around
  incomplete-sibling-transformation, silent-merge-drop-reconstruction,
  cross-platform-test-coverage, and type-representation-matrix-coverage — engine
  fidelity of shipped code. This comment is distinct: it is the maintainer and bot
  jointly designing a better fidelity check, which is precisely the kind of taste-
  and-direction exchange the discriminator dismisses.
---

erights agreed with the bot's own observation (a Symbol.toStringTag data
property cannot repair the TypedArray brand getter for emulated wrappers) and
proposed a stronger future fix — wrapping the getter — as a separately
reviewable commit. New direction offered in an active design dialogue; not a
defect the review process should have anticipated. Dismissed. See comment_url
for the verbatim thread.
