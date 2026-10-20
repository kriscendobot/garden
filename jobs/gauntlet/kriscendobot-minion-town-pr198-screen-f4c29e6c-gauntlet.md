---
panel_head: f4c29e6c52032d099a8949b16d5f2f4a254d343a
pr: https://github.com/kriscendobot/minion.town/pull/198
repo: kriscendobot/minion.town
pr_number: 198
build_job: 
kind: feature
stage: panel
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: kriscendobot-minion-town-pr198-screen-f4c29e6c-gauntlet-panel-1
state: running
created_by: proxy:screen
created_at: 2026-10-20T04:23:25Z
---

# gauntlet kriscendobot-minion-town-pr198-screen-f4c29e6c-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/198 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
