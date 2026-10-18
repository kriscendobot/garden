---
pr: https://github.com/kriscendobot/minion.town/pull/197
repo: kriscendobot/minion.town
pr_number: 197
build_job: 
kind: feature
stage: fix
iteration: 1
max_iterations: 6
resumes: 2
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: kriscendobot-minion-town-pr197-screen-2f63c521-gauntlet-fix-1
state: running
created_by: proxy:screen
created_at: 2026-10-17T15:22:16Z
---

# gauntlet kriscendobot-minion-town-pr197-screen-2f63c521-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/197 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
