---
pr: https://github.com/kriscendobot/minion.town/pull/135
repo: kriscendobot/minion.town
pr_number: 135
build_job: build-npm-minion-town-dev-registry
kind: feature
stage: fix
iteration: 2
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: kriscendobot-minion.town-pr135-gauntlet-fix-2
state: running
created_by: producer
created_at: 2026-09-29T01:03:29Z
---

# gauntlet kriscendobot-minion.town-pr135-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/135 (feature).
Posted by the completion edge of build `build-npm-minion-town-dev-registry`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
