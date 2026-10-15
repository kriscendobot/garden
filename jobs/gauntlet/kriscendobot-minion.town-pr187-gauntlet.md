---
pr: https://github.com/kriscendobot/minion.town/pull/187
repo: kriscendobot/minion.town
pr_number: 187
build_job: heal-minion-town-ad0257e
kind: feature
stage: fix
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: kriscendobot-minion.town-pr187-gauntlet-fix-1
state: running
created_by: gardener
created_at: 2026-10-14T18:17:55Z
---

# gauntlet kriscendobot-minion.town-pr187-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/187 (feature).
Posted by the completion edge of build `heal-minion-town-ad0257e`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
