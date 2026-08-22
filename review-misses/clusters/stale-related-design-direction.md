---
slug: stale-related-design-direction
category: process
status: improvement-dispatched
count: 1
members:
  - kriscendobot-minion.town-pr48-review-b8fd1e6b
prs: [48]
improvement_job: review-improve-stale-related-design-direction
---


A build and its code panels continue toward merge after a related design PR already carries maintainer direction that invalidates the implementation seam, so the maintainer must stop and reconstruct the work.

**Threshold rationale:** # Dispatch rationale: stale-related-design-direction

Dispatch under the severity bypass. The cluster has one major miss on PR 48.
The grounds cite two standing rules that existed before the failed review:
`skills/design-dependency-walk/SKILL.md` defines dependency classification as a
build preparation step, and `roles/jurors/integrator/AGENT.md` requires roadmap
and dependency coherence, including returning work to draft until a prerequisite
concept advances. The related PR 47 changes-requested review predates PR 48's
first commit and all four panel rounds. The failure consumed a full build, clean
stage, four panels, and four fixes before the maintainer closed the PR, so waiting
for two more instances would repeat a high-cost process failure.

Dispatch one builder job with prevention in the producing path, durable sensing
at the review boundary, and a re-litigation test against PRs 47 and 48.
