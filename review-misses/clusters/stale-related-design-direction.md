---
slug: stale-related-design-direction
category: process
status: open
count: 2
members:
  - kriscendobot-minion.town-pr48-review-b8fd1e6b
  - kriscendobot-minion.town-pr160-review-cb820c52
prs: [48, 160]
improvement_job: review-improve-stale-related-design-direction
improved_by: 6e982cd422 scripts/jobs/gardening/related-design-state.sh, panel.sh related-design pre-pass, skills/design-dependency-walk/SKILL.md §0, roles/builder/AGENT.md, roles/jurors/integrator/AGENT.md, skills/panel-hints/SKILL.md, scripts/jobs/test/related-design-sensing-test.sh
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

**Threshold rationale:** **Threshold rationale (2026-10-07, pr160 retro):** This is a genuine post-fix recurrence. The cluster was reopened (count=2, prs=[48,160], recurrence=1), and the store writer sent the maintainer alert `review-miss-recurrence-stale-related-design-direction`. Per review-retrospective § 6, no second improvement round is dispatched on autopilot. It is held for the maintainer.

Diagnosis for that round: the 6e982cd422 sensor (`related-design-state.sh` plus the integrator's related-design axis) keys only on a related PR's outstanding CHANGES_REQUESTED state. On PR 160 the related design (endojs/endo-but-for-bots#1407) had already MERGED with approval. Its resolution removed the per-guest-socket direction that the source issue #149 and the build depended on. Four integrator verdicts saw "merged, nothing outstanding" and cleared it.

Candidate fix: (a) Prevention: at build prep, the builder diffs its source issue's premise against each related design's resolved content (the Open Questions or Decisions it settled), not only that design's review state. (b) Sensing: for a MERGED or APPROVED related design, the pre-pass emits `relation=resolved` with the design-file diff (or its resolved open-question text). The integrator must then state whether the PR's premise survives that resolution, so "merged" is never accepted as automatically clear. Re-litigation test: PR 160 against endojs/endo-but-for-bots#1407 (cross-repo; the related set comes from the PR body's citation).
