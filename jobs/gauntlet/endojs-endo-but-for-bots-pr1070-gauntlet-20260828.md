---
pr: https://github.com/endojs/endo-but-for-bots/pull/1070
repo: endojs/endo-but-for-bots
pr_number: 1070
build_job: 
kind: feature
stage: undraft
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: endojs-endo-but-for-bots-pr1070-gauntlet-20260828-undraft
state: running
created_by: producer
created_at: 2026-08-28T02:14:32Z
---

# gauntlet endojs-endo-but-for-bots-pr1070-gauntlet-20260828

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1070 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
