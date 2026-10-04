---
pr: https://github.com/kriscendobot/minion.town/pull/150
repo: kriscendobot/minion.town
pr_number: 150
build_job: minion-town-claude-cli-production-enable-20261004
kind: feature
stage: panel
iteration: 5
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: kriscendobot-minion-town-pr150-gauntlet-panel-5
state: running
created_by: fixer
created_at: 2026-10-04T16:01:45Z
---

# gauntlet kriscendobot-minion-town-pr150-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/150 (feature).
Posted by the completion edge of build `minion-town-claude-cli-production-enable-20261004`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
