---
pr: https://github.com/endojs/endo-but-for-bots/pull/1480
repo: endojs/endo-but-for-bots
pr_number: 1480
build_job: endo-but-for-bots-ocapn-tcp-for-test-extraction-design-pr-open
kind: feature
stage: panel
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 1
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1480-gauntlet-panel-1
state: running
created_by: producer
arc: endo-ocapn-background
created_at: 2026-10-16T19:41:30Z
---

# gauntlet endojs-endo-but-for-bots-pr1480-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1480 (feature).
Posted by the completion edge of build `endo-but-for-bots-ocapn-tcp-for-test-extraction-design-pr-open`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
