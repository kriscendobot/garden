---
pr: https://github.com/endojs/endo-but-for-bots/pull/989
repo: endojs/endo-but-for-bots
pr_number: 989
build_job: endojs-endo-but-for-bots-pr989-review-984f73e9
kind: feature
stage: fix
iteration: 3
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: endojs-endo-but-for-bots-pr989-gauntlet-fix-3
state: running
created_by: producer
created_at: 2026-08-17T22:24:51Z
---

# gauntlet endojs-endo-but-for-bots-pr989-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/989 (feature).
Posted by the completion edge of build `endojs-endo-but-for-bots-pr989-review-984f73e9`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
