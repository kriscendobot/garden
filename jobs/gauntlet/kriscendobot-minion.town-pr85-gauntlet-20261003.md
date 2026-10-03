---
pr: https://github.com/kriscendobot/minion.town/pull/85
repo: kriscendobot/minion.town
pr_number: 85
build_job: 
kind: feature
stage: panel
iteration: 3
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: kriscendobot-minion.town-pr85-gauntlet-20261003-panel-3
state: running
created_by: gardener
created_at: 2026-10-03T03:24:44Z
---

# gauntlet kriscendobot-minion.town-pr85-gauntlet-20261003

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/85 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
