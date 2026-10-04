---
pr: https://github.com/kriscendobot/minion.town/pull/151
repo: kriscendobot/minion.town
pr_number: 151
build_job: minion-town-shell-to-js-20261004-part1
kind: feature
stage: panel
iteration: 3
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: minion-town-shell-to-js-20261004-part1-gauntlet-panel-3
state: running
created_by: producer
created_at: 2026-10-04T17:57:18Z
---

# gauntlet minion-town-shell-to-js-20261004-part1-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/151 (feature).
Posted by the completion edge of build `minion-town-shell-to-js-20261004-part1`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
