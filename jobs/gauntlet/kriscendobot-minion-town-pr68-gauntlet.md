---
stage_retries: 0
pr: https://github.com/kriscendobot/minion.town/pull/68
repo: kriscendobot/minion.town
pr_number: 68
build_job: 
kind: feature
stage: panel
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: kriscendobot-minion-town-pr68-gauntlet-panel-1
state: running
created_by: gardener
created_at: 2026-09-01T23:16:50Z
---

# gauntlet kriscendobot-minion-town-pr68-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/68 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
