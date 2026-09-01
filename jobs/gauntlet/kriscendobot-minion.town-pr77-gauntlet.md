---
pr: https://github.com/kriscendobot/minion.town/pull/77
repo: kriscendobot/minion.town
pr_number: 77
build_job: 
kind: feature
stage: panel
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: kriscendobot-minion.town-pr77-gauntlet-panel-1
state: running
created_by: design-pr-gauntlet-coverage-audit
created_at: 2026-09-01T18:39:40Z
---

# gauntlet kriscendobot-minion.town-pr77-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/77 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
