---
pr: https://github.com/endojs/endo-but-for-bots/pull/1425
repo: endojs/endo-but-for-bots
pr_number: 1425
build_job: 
kind: feature
stage: fix
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1425-gauntlet-20261007-fix-1
state: running
created_by: producer
arc: endo-ocapn-background
created_at: 2026-10-08T09:30:43Z
---

# gauntlet endojs-endo-but-for-bots-pr1425-gauntlet-20261007

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1425 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
