---
pr: https://github.com/endojs/endo-but-for-bots/pull/282
repo: endojs/endo-but-for-bots
pr_number: 282
build_job: 
kind: feature
stage: panel
iteration: 2
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: endojs-endo-but-for-bots-pr282-gauntlet-20260827-r2-panel-2
state: running
created_by: gardener
created_at: 2026-08-27T17:07:36Z
---

# gauntlet endojs-endo-but-for-bots-pr282-gauntlet-20260827-r2

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/282 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
