---
pr: https://github.com/kriscendobot/minion.town/pull/249
repo: kriscendobot/minion.town
pr_number: 249
build_job: minion-town-api-key-agent-panel3-fixes-20261105
kind: feature
stage: fix
iteration: 5
max_iterations: 6
resumes: 1
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: kriscendobot-minion.town-pr249-gauntlet-fix-5
state: running
created_by: producer
created_at: 2026-11-05T01:22:41Z
---

# gauntlet kriscendobot-minion.town-pr249-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/249 (feature).
Posted by the completion edge of build `minion-town-api-key-agent-panel3-fixes-20261105`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
