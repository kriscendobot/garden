---
pr: https://github.com/kriscendobot/minion.town/pull/159
repo: kriscendobot/minion.town
pr_number: 159
build_job: build-minion-town-claude-account-caddy-route
kind: feature
stage: panel
iteration: 2
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: build-minion-town-claude-account-caddy-route-gauntlet-panel-2
state: running
created_by: producer
arc: claude-on-minion-town
created_at: 2026-10-05T14:18:28Z
---

# gauntlet build-minion-town-claude-account-caddy-route-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/159 (feature).
Posted by the completion edge of build `build-minion-town-claude-account-caddy-route`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
