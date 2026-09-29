---
kind: review-miss
primary_job: endojs-endo-but-for-bots-pr1301-review-3220af4b
verdict: miss
category: process
pr: 1301
cluster: review-feedback-deferred-off-pr
cluster_pattern: A review-feedback worker acknowledges a maintainer's CHANGES_REQUESTED item (records the decision, replies in-thread) but defers the actual code change to a parked or orchestrated job without a reviewer-authorized deferral, so the PR head stays unchanged and the maintainer must re-raise the same feedback.
review_at: 2026-09-20T07:11:18Z
repo: endojs/endo-but-for-bots
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1301#pullrequestreview-5259855118
identity: endojs/endo-but-for-bots#1301:review:5259855118:retro
producing_role: fixer (review-feedback responder)
producing_job: endojs-endo-but-for-bots-pr1301-review-34598631
missed_by: first-loop review responder (roles/fixer/AGENT.md definition of done) and the absence of any addressed-on-head check before the PR awaited re-review
severity: minor
grounds: |
  In paraphrase, this CHANGES_REQUESTED review said the maintainer believed work
  had been lost and pointed back at the earlier naming guidance. Its nine inline
  comments flagged, on the generated agent-tools declarations and daemon help,
  surviving old blob names (a bare fetch and range where byteRange was agreed, a
  bundled getInfo that should be removed, a missing sha256 accessor).

  World check: no work was actually lost. The retcon force-push at
  2026-09-20T04:34Z (ecadf15b9a -> d74ec536a8) preserved the tree (identical blob
  SHAs for the flagged files), and d74ec536a8 still carried getInfo/fetch in
  git-declarations.js. The renames had simply never been applied to the PR. The
  first-loop job for the 2026-09-18 naming review (…-review-34598631) recorded
  design decisions 4 and 5, replied in-thread, and deliberately did not rename
  live code, routing the change to parked orchestrated stages
  (build-rbra-clean-break-20260916, build-rbra-rename-conformance-20260916, the
  latter still in plan/). No reviewer authorized that deferral. The gauntlet
  requested on 2026-09-18 halted in its clean stage with zero panel rounds, so
  nothing between the two reviews checked that the requested changes had landed
  on the head. Two days later the maintainer found the same names and had to
  repeat the feedback.

  A standing rule already covered this: roles/fixer/AGENT.md requires every
  must-fix item be addressed in a commit, deferred only per a reviewer-authorized
  deferral path, or escalated. The item was neither committed nor authorized for
  deferral, so this is a process miss (a rule that failed to bind), not new
  direction. Minor severity: pre-release naming, and the expanded-window
  successor restored the names (96e65a904e) before the PR merged at a39e8a99f.
---

# Miss: endo-but-for-bots #1301 review 5259855118

The maintainer re-raised naming feedback they had already given two days
earlier, suspecting lost work. The actual cause was that the earlier feedback
had been acknowledged and recorded in the design doc, but the code change had
been handed to parked stage jobs that did not run before the maintainer looked
again. The retcon in between did not change the tree. The fixer brief already
forbids an unauthorized deferral like this, but nothing enforced it, and the
halted gauntlet never produced a panel round that could have noticed. See
`comment_url` for the untrusted verbatim review.
