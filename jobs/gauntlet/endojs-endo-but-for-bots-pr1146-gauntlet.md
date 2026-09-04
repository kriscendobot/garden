---
pr: https://github.com/endojs/endo-but-for-bots/pull/1146
repo: endojs/endo-but-for-bots
pr_number: 1146
build_job: fu-endojs-endo-but-for-bots-pr891-gauntlet-fix-1-2
kind: feature
stage: panel
iteration: 4
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1146-gauntlet-panel-4
state: running
created_by: producer
created_at: 2026-09-04T06:50:18Z
---

# gauntlet endojs-endo-but-for-bots-pr1146-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1146 (feature).
Posted by the completion edge of build `fu-endojs-endo-but-for-bots-pr891-gauntlet-fix-1-2`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
