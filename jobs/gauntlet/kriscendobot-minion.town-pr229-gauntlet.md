---
panel_head: 637a9a08856a0f952f7deeffc16d682039f48154
pr: https://github.com/kriscendobot/minion.town/pull/229
repo: kriscendobot/minion.town
pr_number: 229
build_job: build-endo-1575-operation-management-20261103
kind: feature
stage: panel
iteration: 6
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: kriscendobot-minion.town-pr229-gauntlet-panel-6
state: running
created_by: producer
created_at: 2026-11-03T18:53:28Z
---

# gauntlet kriscendobot-minion.town-pr229-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/229 (feature).
Posted by the completion edge of build `build-endo-1575-operation-management-20261103`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
