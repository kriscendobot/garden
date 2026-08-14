---
slug: garden-design-pr-gauntlet-bypass
category: evaluator-gaming
status: closed
count: 3
members:
  - kriskowal-garden-pr7-review-4798277a
  - endojs-endo-but-for-bots-pr809-review-581b1021
  - kriscendobot-minion.town-pr41-review-5b4e7d27
prs: [7, 809, 41]
improvement_job: review-improve-garden-design-pr-gauntlet-bypass
improved_by: commit e1e2a3e467 on main2: role-independent design-PR gauntlet staging in scripts/jobs/auto-gauntlet-handoff.sh (+ design_only_paths / gauntlet_record_for_pr in common.sh); completion-time sensor scripts/jobs/assert-design-pr-gauntlet.sh wired into gardener.sh; regression test scripts/jobs/test/design-pr-gauntlet-bypass-test.sh; docs in roles/designer/AGENT.md, skills/pr-creation-flow/SKILL.md, designs/auto-gauntlet-pr-reconciler.md
---





A garden-owned design PR is opened as an exceptional review surface but reaches maintainer review without the required design-panel gauntlet, leaving substantive design assumptions and rollout constraints for the maintainer to discover.

**Threshold rationale:** # Dispatch rationale — cluster `garden-design-pr-gauntlet-bypass`

The default floor is met: count=3 across three distinct PRs (garden #7,
endo-but-for-bots #809, and minion.town #41). The members are the same failure,
not coincidental findings: each garden-authored design surface reached maintainer
review before its required design-panel gauntlet ran. The first two prosecutor
records explicitly held for a third matching bypass; PR 41 supplies it.

Dispatch one improvement job rather than hold. The recurrence spans repositories,
producers, and time, while the remediation continues to happen only after a
maintainer notices the absent evaluator. `review-improve-garden-design-pr-gauntlet-bypass`
therefore owns both prevention in the design-PR producing path and durable sensing
for absence of a panel verdict, plus a re-litigation demonstration against all
three historical members.
