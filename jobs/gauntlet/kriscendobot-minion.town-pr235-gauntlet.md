---
pr: https://github.com/kriscendobot/minion.town/pull/235
repo: kriscendobot/minion.town
pr_number: 235
build_job: build-minion-town-mcp-resources-primer-20261103
kind: feature
stage: panel
iteration: 5
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: kriscendobot-minion.town-pr235-gauntlet-panel-5
state: running
created_by: producer
created_at: 2026-11-03T22:25:53Z
---

# gauntlet kriscendobot-minion.town-pr235-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/235 (feature).
Posted by the completion edge of build `build-minion-town-mcp-resources-primer-20261103`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
