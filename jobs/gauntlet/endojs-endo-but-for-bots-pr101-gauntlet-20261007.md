---
pr: https://github.com/endojs/endo-but-for-bots/pull/101
repo: endojs/endo-but-for-bots
pr_number: 101
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
created_at: 2026-10-08T16:00:27Z
---

# gauntlet endojs-endo-but-for-bots-pr101-gauntlet-20261007

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/101 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
