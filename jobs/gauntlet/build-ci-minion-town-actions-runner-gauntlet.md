---
pr: https://github.com/kriscendobot/minion.town/pull/145
repo: kriscendobot/minion.town
pr_number: 145
build_job: build-ci-minion-town-actions-runner
kind: feature
stage: panel
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: build-ci-minion-town-actions-runner-gauntlet-panel-1
state: running
created_by: producer
created_at: 2026-09-30T21:06:52Z
---

# gauntlet build-ci-minion-town-actions-runner-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/145 (feature).
Posted by the completion edge of build `build-ci-minion-town-actions-runner`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
