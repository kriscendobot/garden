---
pr: https://github.com/kriscendobot/minion.town/pull/148
repo: kriscendobot/minion.town
pr_number: 148
build_job: 
kind: feature
stage: panel
iteration: 2
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: kriscendobot-minion-town-pr148-gauntlet-restage-20261003-panel-2
state: running
created_by: producer
created_at: 2026-10-03T16:20:09Z
---

# gauntlet kriscendobot-minion-town-pr148-gauntlet-restage-20261003

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/148 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
