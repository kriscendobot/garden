---
pr: https://github.com/kriscendobot/minion.town/pull/183
repo: kriscendobot/minion.town
pr_number: 183
build_job: 
kind: feature
stage: panel
iteration: 4
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: kriscendobot-minion-town-pr183-screen-07e6a4d9-gauntlet-panel-4
state: running
created_by: proxy:screen
created_at: 2026-10-14T09:16:58Z
---

# gauntlet kriscendobot-minion-town-pr183-screen-07e6a4d9-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/183 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
