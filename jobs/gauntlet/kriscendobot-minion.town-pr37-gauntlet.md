---
pr: https://github.com/kriscendobot/minion.town/pull/37
repo: kriscendobot/minion.town
pr_number: 37
build_job: 
kind: feature
stage: panel
iteration: 3
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: kriscendobot-minion.town-pr37-gauntlet-panel-3
state: running
created_by: design-pr-gauntlet-coverage-audit
created_at: 2026-08-17T23:13:09Z
---

# gauntlet kriscendobot-minion.town-pr37-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/37 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
