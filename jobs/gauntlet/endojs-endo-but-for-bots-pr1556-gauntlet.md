---
pr: https://github.com/endojs/endo-but-for-bots/pull/1556
repo: endojs/endo-but-for-bots
pr_number: 1556
build_job: 
kind: feature
stage: viability
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: 
state: pending
created_by: design-pr-gauntlet-coverage-audit
created_at: 2026-10-25T20:42:22Z
---

# gauntlet endojs-endo-but-for-bots-pr1556-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1556 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
