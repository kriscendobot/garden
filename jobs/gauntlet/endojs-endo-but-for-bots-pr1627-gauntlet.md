---
panel_head: 0f7df61459fa6cc647551a944a48ca1245a0e2eb
pr: https://github.com/endojs/endo-but-for-bots/pull/1627
repo: endojs/endo-but-for-bots
pr_number: 1627
build_job: build-endo-claude-agents-capability-slice-after-1576
kind: feature
stage: undraft
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1627-gauntlet-undraft
state: running
created_by: producer
arc: minion-town-claude-api
created_at: 2026-11-01T18:41:08Z
---

# gauntlet endojs-endo-but-for-bots-pr1627-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1627 (feature).
Posted by the completion edge of build `build-endo-claude-agents-capability-slice-after-1576`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
