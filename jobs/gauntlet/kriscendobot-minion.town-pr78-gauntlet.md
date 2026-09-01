---
pr: https://github.com/kriscendobot/minion.town/pull/78
repo: kriscendobot/minion.town
pr_number: 78
build_job: design-minion-town-guest-primer
kind: feature
stage: clean
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: 
state: pending
created_by: producer
created_at: 2026-09-01T22:59:13Z
---

# gauntlet kriscendobot-minion.town-pr78-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/78 (feature).
Posted by the completion edge of build `design-minion-town-guest-primer`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
