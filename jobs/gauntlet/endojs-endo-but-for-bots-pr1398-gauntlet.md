---
pr: https://github.com/endojs/endo-but-for-bots/pull/1398
repo: endojs/endo-but-for-bots
pr_number: 1398
build_job: ebfb-sturdyref-layer8-daemon-formula-20260930-gauntlet-fix-1
kind: feature
stage: panel
iteration: 3
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1398-gauntlet-panel-3
state: running
created_by: producer
arc: unallocated
created_at: 2026-10-07T06:29:25Z
---

# gauntlet endojs-endo-but-for-bots-pr1398-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1398 (feature).
Posted by the completion edge of build `ebfb-sturdyref-layer8-daemon-formula-20260930-gauntlet-fix-1`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
