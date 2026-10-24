---
panel_head: 5e2b6232bc4dfd27083912167ed48cbaf06cb5af
pr: https://github.com/kriscendobot/minion.town/pull/218
repo: kriscendobot/minion.town
pr_number: 218
build_job: 
kind: feature
stage: undraft
iteration: 1
max_iterations: 1
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: kriscendobot-minion-town-pr218-screen-5e2b6232-gauntlet-undraft
state: running
created_by: proxy:screen
created_at: 2026-10-24T19:14:51Z
---

# gauntlet kriscendobot-minion-town-pr218-screen-5e2b6232-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/218 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
