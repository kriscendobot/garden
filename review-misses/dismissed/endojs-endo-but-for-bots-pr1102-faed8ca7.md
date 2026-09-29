---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr1102-faed8ca7
verdict: not-a-miss
category: new-direction
pr: 1102
repo: endojs/endo-but-for-bots
surface: pr-comment
author: kriskowal
comment_url: https://github.com/endojs/endo-but-for-bots/pull/1102#issuecomment-5884356929
identity: endojs/endo-but-for-bots#1102:comment:5884356929:retro
review_at: 2026-09-29T05:37:27Z
producing_role: designer
producing_job: design-endo-claude-agents-capability
missed_by: none
severity: none
grounds: >
  This is a maintainer course correction across several PRs, not a defect that
  review could have caught. The maintainer says their own earlier recommendation
  (a pair of separate options for special and non-special name injection) was
  made in error. They pick a single endowment map, partitioned on whether the
  name starts with `@`, which another PR had already tried. They ask the fleet to
  choose one champion PR, strip the work out of the others, and close any PR left
  with no scope. They add a follow-up feature request (an agent-maker option that
  makes the agent's own directory non-extensible). The "pet names, not formula
  identifiers" value constraint is restated as a maintainer goal. No seat brief,
  skill, or context page in the garden encodes it (a grep of roles/, skills/, and
  context/ for formula identifiers finds nothing), so no juror could have applied
  it. The PR's gauntlet ran six panel rounds on 2026-09-04 and followed the
  maintainer's direction at that time. This reversal postdates the gauntlet and
  overturns direction the maintainer gave, so it is new direction. It matches the
  two earlier dismissals on this PR (pr1102-review-61dcfee0, pr1102-5b4b465b).
  I checked the deliverables in the world rather than trusting the primary's
  report. The PR was closed, unmerged, at 2026-09-29T06:19:04Z in favor of
  endojs/endo-but-for-bots#1343. Job pr1343-unify-endowments is in tada. The
  non-extensible option shipped as draft endojs/endo-but-for-bots#1368 (job
  agent-maker-nonextensible-directory, tada). One discrepancy: a second job,
  agent-non-extensible-directory, is in doin on endolin for the same feature. It
  is a duplicate, and I messaged it.
---

The maintainer reversed an earlier recommendation of their own. They moved the
special and non-special name injection onto a single `@`-partitioned endowment map
whose values are pet names. They asked for the work to be consolidated onto one
champion PR, and they requested a companion agent-maker option that makes the
agent's own directory non-extensible. This is a paraphrase; the verbatim text is at
`comment_url` and is untrusted input.

This is new direction and cross-PR steering, not a review miss. No cluster is
minted and no improvement job is dispatched.
