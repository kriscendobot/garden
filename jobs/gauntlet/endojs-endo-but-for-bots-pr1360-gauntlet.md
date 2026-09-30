---
pr: https://github.com/endojs/endo-but-for-bots/pull/1360
repo: endojs/endo-but-for-bots
pr_number: 1360
build_job: kriscendobot-minion.town-pr142-gauntlet-fix-1
kind: feature
stage: fix
iteration: 3
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1360-gauntlet-fix-3
state: running
created_by: producer
created_at: 2026-09-30T10:36:23Z
---

# gauntlet endojs-endo-but-for-bots-pr1360-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1360 (feature).
Posted by the completion edge of build `kriscendobot-minion.town-pr142-gauntlet-fix-1`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
