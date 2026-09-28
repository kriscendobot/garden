---
pr: https://github.com/kriscendobot/minion.town/pull/86
repo: kriscendobot/minion.town
pr_number: 86
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
created_by: gardener
created_at: 2026-09-28T21:08:05Z
---

# gauntlet kriscendobot-minion.town-pr86-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/86 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
