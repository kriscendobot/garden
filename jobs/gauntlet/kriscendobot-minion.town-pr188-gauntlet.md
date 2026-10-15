---
pr: https://github.com/kriscendobot/minion.town/pull/188
repo: kriscendobot/minion.town
pr_number: 188
build_job: minion-town-ui-gutter-live-refresh
kind: feature
stage: viability
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: 
state: pending
created_by: producer
arc: minion-town-ui
created_at: 2026-10-15T06:11:54Z
---

# gauntlet kriscendobot-minion.town-pr188-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/188 (feature).
Posted by the completion edge of build `minion-town-ui-gutter-live-refresh`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
