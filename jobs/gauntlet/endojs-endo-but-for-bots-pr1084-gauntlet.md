---
pr: https://github.com/endojs/endo-but-for-bots/pull/1084
repo: endojs/endo-but-for-bots
pr_number: 1084
build_job: design-exo-stream-codel-pacing
kind: feature
stage: panel
iteration: 5
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: endojs-endo-but-for-bots-pr1084-gauntlet-panel-5
state: running
created_by: producer
created_at: 2026-08-29T04:32:50Z
---

# gauntlet endojs-endo-but-for-bots-pr1084-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1084 (feature).
Posted by the completion edge of build `design-exo-stream-codel-pacing`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
