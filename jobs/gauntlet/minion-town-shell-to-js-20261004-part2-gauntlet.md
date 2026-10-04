---
pr: https://github.com/kriscendobot/minion.town/pull/152
repo: kriscendobot/minion.town
pr_number: 152
build_job: minion-town-shell-to-js-20261004-part2
kind: feature
stage: panel
iteration: 4
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: minion-town-shell-to-js-20261004-part2-gauntlet-panel-4
state: running
created_by: producer
created_at: 2026-10-04T18:15:46Z
---

# gauntlet minion-town-shell-to-js-20261004-part2-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/152 (feature).
Posted by the completion edge of build `minion-town-shell-to-js-20261004-part2`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
