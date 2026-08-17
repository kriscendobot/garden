---
pr: https://github.com/kriscendobot/minion.town/pull/39
repo: kriscendobot/minion.town
pr_number: 39
build_job: kriscendobot-minion.town-pr39-review-fb0be7ca
kind: feature
stage: panel
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: kriscendobot-minion.town-pr39-gauntlet-panel-1
state: running
created_by: producer
created_at: 2026-08-17T12:27:37Z
---

# gauntlet kriscendobot-minion.town-pr39-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/39 (feature).
Posted by the completion edge of build `kriscendobot-minion.town-pr39-review-fb0be7ca`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
