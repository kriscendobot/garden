---
kind: review-miss
primary_job: kriscendobot-minion.town-pr160-review-cb820c52
verdict: miss
category: process
pr: 160
cluster: stale-related-design-direction
cluster_pattern: A build and its code panels continue toward merge after a related design PR already carries maintainer direction that invalidates the implementation seam, so the maintainer must stop and reconstruct the work.
review_at: 2026-10-06T03:25:06Z
repo: kriscendobot/minion.town
surface: pr-review-body
author: kriskowal
comment_url: https://github.com/kriscendobot/minion.town/pull/160#pullrequestreview-5423461085
identity: kriscendobot/minion.town#160:review:5423461085:retro
producing_role: builder
producing_job: build-minion-town-claude-guest-scoped-mcp
missed_by: builder design-dependency walk and integrator seat across six code-panel rounds (related-design pre-pass checks only outstanding changes-requested state)
severity: major
grounds: |
  Paraphrase: the maintainer asked whether PR 160 was an abandoned design
  tangent. The primary agreed, closed PR 160 and its source issue #149 at
  2026-10-06T05:19Z, and the maintainer did not dispute it. Verified live:
  both are closed, and PR 160 was never merged.

  This was knowable before the build. Issue #149 proposed a guest-scoped
  bootstrap (a per-guest socket or connect token) as the structural fix.
  The related upstream design, endojs/endo-but-for-bots#1407, merged at
  2026-10-05T14:55Z with kriskowal's approval. It removed the per-guest
  socket proposal and resolved the open question in favor of one root
  socket, narrowed by an object-capability guest lookup held in the trusted
  broker. It also says a separate socket per guest adds lifecycle hazards.
  PR 160 opened 14 minutes later and cited #1407 as "the shape settled".
  It still added a per-guest broker-socket lifecycle (a broker directory, a
  sweep, and reaping), and six fix rounds then hardened that lifecycle.

  The standing check from the closed improvement (6e982cd422) did not bind
  here. related-design-state.sh and the integrator's related-design axis
  ask only whether a related PR still holds an outstanding
  changes-requested review. Integrator verdicts in panel rounds 1, 2, 4
  and 5 each named #1407, found it merged or approved with no outstanding
  direction, and cleared it. None of them compared the PR's premise (from
  #149) against what #1407 actually resolved. A merged or approved design
  whose resolution reverses the implementation's premise is the same failure
  as an outstanding changes-requested design, reached through a different
  review state. The sensor met the letter of its check while missing its
  purpose. Severity is major: one full build, a clean pass, six panel rounds
  and six fixes were spent before the maintainer had to stop the work.
