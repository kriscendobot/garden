---
pr: https://github.com/endojs/endo-but-for-bots/pull/1529
repo: endojs/endo-but-for-bots
pr_number: 1529
build_job: build-daemon-debug-worker-restart-phase-3-chat-integration-open-pr
kind: feature
stage: panel
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1529-gauntlet-panel-1
state: running
created_by: producer
arc: moonshots
created_at: 2026-10-22T03:15:15Z
---

# gauntlet endojs-endo-but-for-bots-pr1529-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1529 (feature).
Posted by the completion edge of build `build-daemon-debug-worker-restart-phase-3-chat-integration-open-pr`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
