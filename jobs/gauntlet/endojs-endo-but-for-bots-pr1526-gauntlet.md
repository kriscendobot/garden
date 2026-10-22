---
panel_head: ee8abe16961bcb36912bb54f090469434400905d
pr: https://github.com/endojs/endo-but-for-bots/pull/1526
repo: endojs/endo-but-for-bots
pr_number: 1526
build_job: design-endor-tui-phase-breakdown-open-pr
kind: feature
stage: undraft
iteration: 2
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1526-gauntlet-undraft
state: running
created_by: producer
arc: moonshots
created_at: 2026-10-22T01:54:34Z
---

# gauntlet endojs-endo-but-for-bots-pr1526-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1526 (feature).
Posted by the completion edge of build `design-endor-tui-phase-breakdown-open-pr`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
