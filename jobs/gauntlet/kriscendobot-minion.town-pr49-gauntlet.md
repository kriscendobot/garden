---
pr: https://github.com/kriscendobot/minion.town/pull/49
repo: kriscendobot/minion.town
pr_number: 49
build_job: kriscendobot-minion.town-pr41-vitals-weblet-reconciliation
kind: feature
stage: fix
iteration: 5
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: kriscendobot-minion.town-pr49-gauntlet-fix-5
state: running
created_by: producer
created_at: 2026-08-18T04:49:51Z
---

# gauntlet kriscendobot-minion.town-pr49-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/49 (feature).
Posted by the completion edge of build `kriscendobot-minion.town-pr41-vitals-weblet-reconciliation`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
