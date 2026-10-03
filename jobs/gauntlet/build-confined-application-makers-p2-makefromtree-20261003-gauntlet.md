---
pr: https://github.com/endojs/endo-but-for-bots/pull/1419
repo: endojs/endo-but-for-bots
pr_number: 1419
build_job: build-confined-application-makers-p2-makefromtree-20261003
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
created_at: 2026-10-03T06:20:06Z
---

# gauntlet build-confined-application-makers-p2-makefromtree-20261003-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1419 (feature).
Posted by the completion edge of build `build-confined-application-makers-p2-makefromtree-20261003`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
