---
pr: https://github.com/endojs/endo-but-for-bots/pull/935
repo: endojs/endo-but-for-bots
pr_number: 935
build_job: minion-town-guest-reminders-capability-experiment
kind: feature
stage: panel
iteration: 3
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: minion-town-guest-reminders-capability-experiment-gauntlet-panel-3
state: running
created_by: producer
created_at: 2026-09-04T06:08:16Z
---

# gauntlet minion-town-guest-reminders-capability-experiment-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/935 (feature).
Posted by the completion edge of build `minion-town-guest-reminders-capability-experiment`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
