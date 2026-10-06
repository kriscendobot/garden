---
pr: https://github.com/kriscendobot/minion.town/pull/163
repo: kriscendobot/minion.town
pr_number: 163
build_job: build-minion-town-caddy-restart-on-env-change
kind: feature
stage: panel
iteration: 6
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: kriscendobot-minion.town-pr163-gauntlet-20261005-panel-6
state: running
created_by: liaison
created_at: 2026-10-05T23:08:54Z
---

# gauntlet kriscendobot-minion.town-pr163-gauntlet-20261005

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/163 (feature).
Posted by the completion edge of build `build-minion-town-caddy-restart-on-env-change`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
