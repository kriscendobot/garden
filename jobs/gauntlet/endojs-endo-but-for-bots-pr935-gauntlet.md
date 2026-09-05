---
pr: https://github.com/endojs/endo-but-for-bots/pull/935
repo: endojs/endo-but-for-bots
pr_number: 935
build_job: 
kind: feature
stage: panel
iteration: 6
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr935-gauntlet-panel-6
state: running
created_by: design-pr-gauntlet-coverage-audit
created_at: 2026-09-05T12:37:49Z
---

# gauntlet endojs-endo-but-for-bots-pr935-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/935 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
