---
pr: https://github.com/endojs/endo-but-for-bots/pull/1597
repo: endojs/endo-but-for-bots
pr_number: 1597
build_job: build-daemon-agent-tools-phase-five-contract-test
kind: feature
stage: viability
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1597-gauntlet-viability
state: running
created_by: producer
arc: minion-town-claude-api
created_at: 2026-10-31T19:31:54Z
---

# gauntlet endojs-endo-but-for-bots-pr1597-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1597 (feature).
Posted by the completion edge of build `build-daemon-agent-tools-phase-five-contract-test`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
