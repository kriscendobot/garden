---
pr: https://github.com/kriscendobot/moddable/pull/2
repo: kriscendobot/moddable
pr_number: 2
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
arc: moonshots
created_at: 2026-10-08T12:40:22Z
---

# gauntlet kriscendobot-moddable-pr2-gauntlet-20261007

Staged gauntlet run over https://github.com/kriscendobot/moddable/pull/2 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
