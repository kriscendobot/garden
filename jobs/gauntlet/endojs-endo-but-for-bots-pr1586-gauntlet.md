---
pr: https://github.com/endojs/endo-but-for-bots/pull/1586
repo: endojs/endo-but-for-bots
pr_number: 1586
build_job: build-fs-interface-reconciliation
kind: feature
stage: clean
iteration: 0
max_iterations: 6
resumes: 2
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1586-gauntlet-clean
state: running
created_by: producer
arc: unallocated
created_at: 2026-10-31T06:09:51Z
---

# gauntlet endojs-endo-but-for-bots-pr1586-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1586 (feature).
Posted by the completion edge of build `build-fs-interface-reconciliation`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
