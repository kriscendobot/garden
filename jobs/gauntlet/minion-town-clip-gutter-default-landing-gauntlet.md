---
panel_head: 43a1387084e1791f5d4418d9145041e590333891
pr: https://github.com/kriscendobot/minion.town/pull/143
repo: kriscendobot/minion.town
pr_number: 143
build_job: minion-town-clip-gutter-default-landing
kind: feature
stage: panel
iteration: 3
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: minion-town-clip-gutter-default-landing-gauntlet-panel-3
state: running
created_by: producer
created_at: 2026-09-30T04:44:15Z
---

# gauntlet minion-town-clip-gutter-default-landing-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/143 (feature).
Posted by the completion edge of build `minion-town-clip-gutter-default-landing`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
