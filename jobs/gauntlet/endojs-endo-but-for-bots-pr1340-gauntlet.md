---
pr: https://github.com/endojs/endo-but-for-bots/pull/1340
repo: endojs/endo-but-for-bots
pr_number: 1340
build_job: endojs-endo-but-for-bots-pr1340-review-85c8bc95
kind: feature
stage: panel
iteration: 2
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1340-gauntlet-panel-2
state: running
created_by: producer
created_at: 2026-09-30T21:09:59Z
---

# gauntlet endojs-endo-but-for-bots-pr1340-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1340 (feature).
Posted by the completion edge of build `endojs-endo-but-for-bots-pr1340-review-85c8bc95`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
