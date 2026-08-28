---
pr: https://github.com/kriscendobot/minion.town/pull/56
repo: kriscendobot/minion.town
pr_number: 56
build_job: design-minion-town-invitation-only-guests
kind: feature
stage: panel
iteration: 4
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: kriscendobot-minion.town-pr56-gauntlet-panel-4
state: running
created_by: producer
created_at: 2026-08-27T23:13:04Z
---

# gauntlet kriscendobot-minion.town-pr56-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/56 (feature).
Posted by the completion edge of build `design-minion-town-invitation-only-guests`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
