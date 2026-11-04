---
pr: https://github.com/kriscendobot/minion.town/pull/246
repo: kriscendobot/minion.town
pr_number: 246
build_job: build-minion-town-remove-open-in-new-tab-20261104
kind: feature
stage: fix
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: kriscendobot-minion.town-pr246-gauntlet-fix-1
state: running
created_by: producer
created_at: 2026-11-04T23:07:52Z
---

# gauntlet kriscendobot-minion.town-pr246-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/246 (feature).
Posted by the completion edge of build `build-minion-town-remove-open-in-new-tab-20261104`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
