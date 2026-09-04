---
pr: https://github.com/kriscendobot/minion.town/pull/89
repo: kriscendobot/minion.town
pr_number: 89
build_job: minion-town-clip-formula-id-origin-gc
kind: feature
stage: fix
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: kriscendobot-minion.town-pr89-gauntlet-fix-1
state: running
created_by: producer
created_at: 2026-09-04T04:45:13Z
---

# gauntlet kriscendobot-minion.town-pr89-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/89 (feature).
Posted by the completion edge of build `minion-town-clip-formula-id-origin-gc`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
