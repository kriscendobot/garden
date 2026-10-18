---
pr: https://github.com/kriscendobot/vattr97/pull/1
repo: kriscendobot/vattr97
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
current_child: 
state: pending
created_by: producer
arc: unallocated
created_at: 2026-10-18T19:57:30Z
---

# gauntlet kriscendobot-vattr97-pr1-gauntlet-20261007

Staged gauntlet run over https://github.com/kriscendobot/vattr97/pull/1 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
