---
panel_head: b942fb977133562f8bde4865bbf5e5d3602e20f2
pr: https://github.com/kriscendobot/minion.town/pull/237
repo: kriscendobot/minion.town
pr_number: 237
build_job: build-minion-town-responder-test-mailbox-poll
kind: feature
stage: panel
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: kriscendobot-minion.town-pr237-gauntlet-panel-1
state: running
created_by: producer
created_at: 2026-11-04T01:05:39Z
---

# gauntlet kriscendobot-minion.town-pr237-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/237 (feature).
Posted by the completion edge of build `build-minion-town-responder-test-mailbox-poll`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
