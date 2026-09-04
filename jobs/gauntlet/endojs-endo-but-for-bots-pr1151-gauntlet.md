---
pr: https://github.com/endojs/endo-but-for-bots/pull/1151
repo: endojs/endo-but-for-bots
pr_number: 1151
build_job: design-endo-but-for-bots-eliminate-single-segment-petname-paths
kind: feature
stage: panel
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1151-gauntlet-panel-1
state: running
created_by: producer
created_at: 2026-09-04T08:09:26Z
---

# gauntlet endojs-endo-but-for-bots-pr1151-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1151 (feature).
Posted by the completion edge of build `design-endo-but-for-bots-eliminate-single-segment-petname-paths`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
