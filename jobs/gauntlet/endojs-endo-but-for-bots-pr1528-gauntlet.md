---
pr: https://github.com/endojs/endo-but-for-bots/pull/1528
repo: endojs/endo-but-for-bots
pr_number: 1528
build_job: design-endor-bus-tui-phase-breakdown-open-pr
kind: feature
stage: viability
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1528-gauntlet-viability
state: running
created_by: producer
arc: moonshots
created_at: 2026-10-22T02:06:05Z
---

# gauntlet endojs-endo-but-for-bots-pr1528-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1528 (feature).
Posted by the completion edge of build `design-endor-bus-tui-phase-breakdown-open-pr`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
