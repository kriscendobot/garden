---
pr: https://github.com/endojs/endo-but-for-bots/pull/1100
repo: endojs/endo-but-for-bots
pr_number: 1100
build_job: 
kind: feature
stage: fix
iteration: 3
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: ebfb-exo-stream-pr1100-gauntlet-20260923b-fix-3
state: running
created_by: liaison
created_at: 2026-09-23T23:23:46Z
---

# gauntlet ebfb-exo-stream-pr1100-gauntlet-20260923b

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1100 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
