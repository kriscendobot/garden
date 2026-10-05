---
pr: https://github.com/endojs/endo-but-for-bots/pull/1426
repo: endojs/endo-but-for-bots
pr_number: 1426
build_job: build-familiar-localhttp-protocol
kind: feature
stage: panel
iteration: 2
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: build-familiar-localhttp-protocol-gauntlet-panel-2
state: running
created_by: producer
arc: minion-town-ui
created_at: 2026-10-05T12:24:01Z
---

# gauntlet build-familiar-localhttp-protocol-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1426 (feature).
Posted by the completion edge of build `build-familiar-localhttp-protocol`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
