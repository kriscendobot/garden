---
pr: https://github.com/endojs/endo-but-for-bots/pull/1645
repo: endojs/endo-but-for-bots
pr_number: 1645
build_job: agentry-makepiagent-drops-system-messages-fix-open-pr
kind: feature
stage: fix
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1645-gauntlet-fix-1
state: running
created_by: producer
arc: moonshots
created_at: 2026-11-03T05:25:11Z
---

# gauntlet endojs-endo-but-for-bots-pr1645-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1645 (feature).
Posted by the completion edge of build `agentry-makepiagent-drops-system-messages-fix-open-pr`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
