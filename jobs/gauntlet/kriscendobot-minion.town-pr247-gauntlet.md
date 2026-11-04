---
pr: https://github.com/kriscendobot/minion.town/pull/247
repo: kriscendobot/minion.town
pr_number: 247
build_job: design-minion-town-ordered-gutter-context-menu-20261104
kind: feature
stage: viability
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: kriscendobot-minion.town-pr247-gauntlet-viability
state: running
created_by: producer
created_at: 2026-11-04T23:34:08Z
---

# gauntlet kriscendobot-minion.town-pr247-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/247 (feature).
Posted by the completion edge of build `design-minion-town-ordered-gutter-context-menu-20261104`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
