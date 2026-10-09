---
pr: https://github.com/kriscendobot/minion.town/pull/173
repo: kriscendobot/minion.town
pr_number: 173
build_job: 
kind: feature
stage: fix
iteration: 5
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 1
max_stage_retries: 2
current_child: kriscendobot-minion.town-pr173-gauntlet-fix-5
state: running
created_by: design-pr-gauntlet-coverage-audit
created_at: 2026-10-08T19:45:21Z
---

# gauntlet kriscendobot-minion.town-pr173-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/173 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
