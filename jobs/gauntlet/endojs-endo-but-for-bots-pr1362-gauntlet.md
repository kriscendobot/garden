---
pr: https://github.com/endojs/endo-but-for-bots/pull/1362
repo: endojs/endo-but-for-bots
pr_number: 1362
build_job: build-npm-minion-town-dev-registry
kind: feature
stage: clean
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1362-gauntlet-clean
state: running
created_by: producer
created_at: 2026-09-29T01:03:24Z
---

# gauntlet endojs-endo-but-for-bots-pr1362-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1362 (feature).
Posted by the completion edge of build `build-npm-minion-town-dev-registry`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
