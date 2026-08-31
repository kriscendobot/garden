---
pr: https://github.com/endojs/endo-but-for-bots/pull/138
repo: endojs/endo-but-for-bots
pr_number: 138
build_job: 
kind: feature
stage: panel
iteration: 5
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: endojs-endo-but-for-bots-pr138-gauntlet-panel-5
state: running
created_by: design-pr-gauntlet-coverage-audit
created_at: 2026-08-30T07:39:23Z
---

# gauntlet endojs-endo-but-for-bots-pr138-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/138 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
