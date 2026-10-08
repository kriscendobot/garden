---
pr: https://github.com/kriscendobot/minion.town/pull/168
repo: kriscendobot/minion.town
pr_number: 168
build_job: design-minion-town-oauth-bonds
kind: feature
stage: fix
iteration: 6
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: kriscendobot-minion.town-pr168-gauntlet-fix-6
state: running
created_by: producer
arc: minion-town-ui
created_at: 2026-10-07T22:13:09Z
---

# gauntlet kriscendobot-minion.town-pr168-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/168 (feature).
Posted by the completion edge of build `design-minion-town-oauth-bonds`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
