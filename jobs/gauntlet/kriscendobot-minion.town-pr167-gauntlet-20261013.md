---
panel_head: 8368f8c66ac60b810242b7210e2529fb12ad5008
pr: https://github.com/kriscendobot/minion.town/pull/167
repo: kriscendobot/minion.town
pr_number: 167
build_job: 
kind: feature
stage: panel
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 1
max_stage_retries: 2
current_child: kriscendobot-minion.town-pr167-gauntlet-20261013-panel-1
state: running
created_by: gardener
created_at: 2026-10-13T09:15:04Z
---

# gauntlet kriscendobot-minion.town-pr167-gauntlet-20261013

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/167 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
