---
stage_retries: 0
pr: https://github.com/endojs/endo-but-for-bots/pull/891
repo: endojs/endo-but-for-bots
pr_number: 891
build_job: 
kind: feature
stage: fix
iteration: 4
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: endojs-endo-but-for-bots-pr891-gauntlet-fix-4
state: running
created_by: design-pr-gauntlet-coverage-audit
created_at: 2026-08-30T06:39:26Z
---

# gauntlet endojs-endo-but-for-bots-pr891-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/891 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
