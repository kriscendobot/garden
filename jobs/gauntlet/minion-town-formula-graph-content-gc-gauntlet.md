---
stage_retries: 0
pr: https://github.com/kriscendobot/minion.town/pull/83
repo: kriscendobot/minion.town
pr_number: 83
build_job: minion-town-formula-graph-content-gc
kind: feature
stage: panel
iteration: 2
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: minion-town-formula-graph-content-gc-gauntlet-panel-2
state: running
created_by: producer
created_at: 2026-09-03T21:44:50Z
---

# gauntlet minion-town-formula-graph-content-gc-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/83 (feature).
Posted by the completion edge of build `minion-town-formula-graph-content-gc`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
