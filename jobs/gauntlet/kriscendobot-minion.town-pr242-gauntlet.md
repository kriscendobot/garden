---
panel_head: 49320b7637018f3400001df3f7bc4b72539cdbf4
pr: https://github.com/kriscendobot/minion.town/pull/242
repo: kriscendobot/minion.town
pr_number: 242
build_job: 
kind: feature
stage: panel
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: kriscendobot-minion.town-pr242-gauntlet-panel-1
state: running
created_by: design-pr-gauntlet-coverage-audit
created_at: 2026-11-05T10:33:16Z
---

# gauntlet kriscendobot-minion.town-pr242-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/242 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
