---
kind: review-miss-dismissed
primary_job: kriscendobot-garden-pr73-review-6e23fb68
verdict: not-a-miss
category: new-direction
pr: 73
repo: kriscendobot/garden
identity: kriscendobot/garden#73:review:5098606293:retro
comment_url: https://github.com/kriscendobot/garden/pull/73#pullrequestreview-5098606293
review_at: 2026-09-03T06:36:19Z
severity: minor
grounds: |
  Forward design direction, first stated in the comment. PR #73
  (design: follower self-deploy) is an open-questions DESIGN PR — it carries the
  <!-- garden-design-open-questions --> marker and a six-question maintainer-facing
  Open questions section, so by construction it is a maintainer answer-surface that
  exists precisely to elicit maintainer direction, not a mergeable implementation.
  Its authored scope was a follower-only headless deploy that kept the LEADER
  session-orchestrated (the deliberate asymmetry stated in designs/deliberate-deploy.md).

  In review 5098606293 (CHANGES_REQUESTED, kriskowal) the maintainer expresses a
  NEW architectural preference: the leader should ALSO self-deploy, reframed as a
  fleet-wide ROLLING deploy that uses followers as CANARIES — leader orchestrates
  drain -> upgrade -> lift -> validate, tests each follower post-deploy, and watches
  for job-processing regressions. This reverses the design's core asymmetry and
  widens a follower-only mechanism into a fleet-wide posture. It is not a bug, spec
  violation, missed edge case, or violated convention the panel knows from a seat
  brief, skill, or standing instruction — no juror seat, gate, or standing rule
  encodes a preferred deploy topology (leader-canary rolling vs follower-only
  headless). Nobody could have anticipated the maintainer's topology choice before
  he named it. This is taste/scope/new-direction, the design process working as
  intended for an open-questions PR, not a review-process miss.

  Not evaluator-gaming/avoidance: the gauntlet genuinely ran on this PR —
  journal/jobs/tada/ holds kriscendobot-garden-pr73-gauntlet-clean,
  -gauntlet-panel-1, -gauntlet, -gauntlet-undraft, and -conduct for pr73 — so the
  evaluator was exercised, not skipped, and the measurement did not move while the
  target stood still. The primary job (6e23fb68) genuinely delivered and did NOT
  close as a no-op: commit 9fbe151be5 on design/follower-self-deploy reframed
  designs/follower-self-deploy.md ("Rolling deploy: the leader orchestrates a fleet
  upgrade with followers as canaries", all six required points), rewrote the
  designs/deliberate-deploy.md narrowing note, refreshed the PR body, and posted an
  acknowledgment re-requesting review. PR #73 merged 2026-09-04, and the landed
  posture is now documented in CLAUDE.md (the leader-orchestrated rolling deploy,
  followers-first canaries, leader last). The directive deliverable demonstrably
  exists; the discrepancy the retro guards against (a primary asserting a phantom
  resolution) does not apply here.
---

Dismissal: maintainer review 5098606293 on design PR #73 requested a new,
broader deploy topology (leader self-deploys via a fleet-wide rolling deploy with
followers as canaries) that reverses the authored design's leader/follower
asymmetry. This is forward design direction first stated in the comment on an
open-questions design PR whose purpose is to elicit exactly such maintainer
steering — not something any seat, gate, or standing instruction could have
anticipated. See comment_url for the verbatim (untrusted) text.
