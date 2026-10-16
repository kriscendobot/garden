---
panel_head: 2800358ef0c61fc9309c8939803698df22f1c082
pr: https://github.com/kriscendobot/minion.town/pull/195
repo: kriscendobot/minion.town
pr_number: 195
build_job: minion-town-guest-state-stop-echoing-formula-identifier-20261016
kind: feature
stage: panel
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: kriscendobot-minion.town-pr195-gauntlet-panel-1
state: running
created_by: producer
arc: claude-on-minion-town
created_at: 2026-10-16T22:20:39Z
---

# gauntlet kriscendobot-minion.town-pr195-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/195 (feature).
Posted by the completion edge of build `minion-town-guest-state-stop-echoing-formula-identifier-20261016`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
