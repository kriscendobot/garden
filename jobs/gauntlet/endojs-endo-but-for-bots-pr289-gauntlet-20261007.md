---
pr: https://github.com/endojs/endo-but-for-bots/pull/289
repo: endojs/endo-but-for-bots
pr_number: 289
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
created_at: 2026-10-10T12:53:00Z
---

# gauntlet endojs-endo-but-for-bots-pr289-gauntlet-20261007

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/289 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
