---
pr: https://github.com/endojs/endo-but-for-bots/pull/1428
repo: endojs/endo-but-for-bots
pr_number: 1428
build_job: endo-but-for-bots-upstream-master-pin-20261006
kind: feature
stage: fix
iteration: 2
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1428-gauntlet-fix-2
state: running
created_by: producer
created_at: 2026-10-06T02:57:33Z
---

# gauntlet endojs-endo-but-for-bots-pr1428-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1428 (feature).
Posted by the completion edge of build `endo-but-for-bots-upstream-master-pin-20261006`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
