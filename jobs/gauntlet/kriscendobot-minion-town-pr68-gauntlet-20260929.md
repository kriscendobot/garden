---
pr: https://github.com/kriscendobot/minion.town/pull/68
repo: kriscendobot/minion.town
pr_number: 68
build_job: 
kind: feature
stage: panel
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: kriscendobot-minion-town-pr68-gauntlet-20260929-panel-1
state: running
created_by: producer
created_at: 2026-09-29T19:33:25Z
---

# gauntlet kriscendobot-minion-town-pr68-gauntlet-20260929

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/68 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
