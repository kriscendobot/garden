---
pr: https://github.com/kriscendobot/minion.town/pull/146
repo: kriscendobot/minion.town
pr_number: 146
build_job: minion-town-pr140-endo-cancel
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
created_at: 2026-10-01T13:59:15Z
---

# gauntlet minion-town-pr140-endo-cancel-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/146 (feature).
Posted by the completion edge of build `minion-town-pr140-endo-cancel`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
