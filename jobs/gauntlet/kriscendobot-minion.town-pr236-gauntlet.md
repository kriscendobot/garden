---
pr: https://github.com/kriscendobot/minion.town/pull/236
repo: kriscendobot/minion.town
pr_number: 236
build_job: 
kind: feature
stage: panel
iteration: 3
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: kriscendobot-minion.town-pr236-gauntlet-panel-3
state: running
created_by: gardener
created_at: 2026-11-04T00:21:31Z
---

# gauntlet kriscendobot-minion.town-pr236-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/236 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
