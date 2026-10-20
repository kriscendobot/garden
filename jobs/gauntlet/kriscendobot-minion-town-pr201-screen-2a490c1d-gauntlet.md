---
pr: https://github.com/kriscendobot/minion.town/pull/201
repo: kriscendobot/minion.town
pr_number: 201
build_job: 
kind: feature
stage: fix
iteration: 2
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: kriscendobot-minion-town-pr201-screen-2a490c1d-gauntlet-fix-2
state: running
created_by: proxy:screen
created_at: 2026-10-19T23:08:12Z
---

# gauntlet kriscendobot-minion-town-pr201-screen-2a490c1d-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/201 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
