---
pr: https://github.com/kriscendobot/minion.town/pull/252
repo: kriscendobot/minion.town
pr_number: 252
build_job: 
kind: feature
stage: viability
iteration: 0
max_iterations: 1
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: kriscendobot-minion-town-pr252-screen-528d4a1f-gauntlet-viability
state: running
created_by: proxy:screen
created_at: 2026-11-07T19:19:53Z
---

# gauntlet kriscendobot-minion-town-pr252-screen-528d4a1f-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/252 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
