---
pr: https://github.com/endojs/endo-but-for-bots/pull/508
repo: endojs/endo-but-for-bots
pr_number: 508
build_job: 
kind: feature
stage: clean
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: 
state: pending
created_by: design-pr-gauntlet-coverage-audit
created_at: 2026-08-30T06:48:10Z
---

# gauntlet endojs-endo-but-for-bots-pr508-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/508 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
