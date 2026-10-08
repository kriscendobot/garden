---
pr: https://github.com/kriscendobot/endo-but-for-bots/pull/1
repo: kriscendobot/endo-but-for-bots
pr_number: 1
build_job: 
kind: feature
stage: viability
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: kriscendobot-endo-but-for-bots-pr1-gauntlet-20261007-viability
state: running
created_by: producer
arc: moonshots
created_at: 2026-10-08T12:35:10Z
---

# gauntlet kriscendobot-endo-but-for-bots-pr1-gauntlet-20261007

Staged gauntlet run over https://github.com/kriscendobot/endo-but-for-bots/pull/1 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
