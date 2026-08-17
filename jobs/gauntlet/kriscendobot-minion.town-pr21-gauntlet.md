---
pr: https://github.com/kriscendobot/minion.town/pull/21
repo: kriscendobot/minion.town
pr_number: 21
build_job: 
kind: feature
stage: clean
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: kriscendobot-minion.town-pr21-gauntlet-clean
state: running
created_by: design-pr-gauntlet-coverage-audit
created_at: 2026-08-17T23:13:25Z
---

# gauntlet kriscendobot-minion.town-pr21-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/21 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
