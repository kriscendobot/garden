---
pr: https://github.com/kriscendobot/finbot/pull/5
repo: kriscendobot/finbot
pr_number: 5
build_job: finbot-progress-20260729-195004
kind: feature
stage: panel
iteration: 1
max_iterations: 6
current_child: finbot-progress-20260729-195004-gauntlet-panel-1
state: running
created_by: producer
created_at: 2026-07-29T19:54:28Z
---

# gauntlet finbot-progress-20260729-195004-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/finbot/pull/5 (feature).
Posted by the completion edge of build `finbot-progress-20260729-195004`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
