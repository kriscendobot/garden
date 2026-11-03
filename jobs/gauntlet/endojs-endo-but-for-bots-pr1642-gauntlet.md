---
pr: https://github.com/endojs/endo-but-for-bots/pull/1642
repo: endojs/endo-but-for-bots
pr_number: 1642
build_job: endopi-provider-registry-and-oauth-build-open-pr
kind: feature
stage: panel
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1642-gauntlet-panel-1
state: running
created_by: producer
arc: moonshots
created_at: 2026-11-03T02:03:28Z
---

# gauntlet endojs-endo-but-for-bots-pr1642-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1642 (feature).
Posted by the completion edge of build `endopi-provider-registry-and-oauth-build-open-pr`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
