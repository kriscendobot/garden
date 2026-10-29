---
panel_head: 1286f427b576718fa6d25756ea662b07b8467552
pr: https://github.com/endojs/endo-but-for-bots/pull/1431
repo: endojs/endo-but-for-bots
pr_number: 1431
build_job: endojs-endo-but-for-bots-pr1431-design-panel-20261029
kind: feature
stage: undraft
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1431-gauntlet-20261029-c3ab267ef93b-undraft
state: running
created_by: endojs-endo-but-for-bots-pr1431-design-panel-20261029
created_at: 2026-10-29T15:27:03Z
---

# gauntlet endojs-endo-but-for-bots-pr1431-gauntlet-20261029-c3ab267ef93b

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1431 (feature).
Posted by the completion edge of build `endojs-endo-but-for-bots-pr1431-design-panel-20261029`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
