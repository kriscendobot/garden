---
pr: https://github.com/kriscendobot/minion.town/pull/166
repo: kriscendobot/minion.town
pr_number: 166
build_job: 
kind: feature
stage: fix
iteration: 1
max_iterations: 3
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: kriscendobot-minion.town-pr166-gauntlet-20261010-fix-1
state: running
created_by: gardener
created_at: 2026-10-10T03:07:58Z
---

# gauntlet kriscendobot-minion.town-pr166-gauntlet-20261010

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/166 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
