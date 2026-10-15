---
pr: https://github.com/endojs/endo-but-for-bots/pull/412
repo: endojs/endo-but-for-bots
pr_number: 412
build_job: endojs-endo-but-for-bots-pr356-gauntlet-20261007-fix-2
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
created_at: 2026-10-15T21:08:47Z
---

# gauntlet endojs-endo-but-for-bots-pr412-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/412 (feature).
Posted by the completion edge of build `endojs-endo-but-for-bots-pr356-gauntlet-20261007-fix-2`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
