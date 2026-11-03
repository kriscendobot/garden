---
pr: https://github.com/kriscendobot/minion.town/pull/234
repo: kriscendobot/minion.town
pr_number: 234
build_job: 
kind: feature
stage: panel
iteration: 1
max_iterations: 1
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: kriscendobot-minion-town-pr234-screen-0e10e33b-gauntlet-panel-1
state: running
created_by: proxy:screen
created_at: 2026-11-03T18:17:57Z
---

# gauntlet kriscendobot-minion-town-pr234-screen-0e10e33b-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/234 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
