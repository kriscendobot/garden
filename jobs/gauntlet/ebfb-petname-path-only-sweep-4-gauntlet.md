---
pr: https://github.com/endojs/endo-but-for-bots/pull/1390
repo: endojs/endo-but-for-bots
pr_number: 1390
build_job: ebfb-petname-path-only-sweep-4
kind: feature
stage: clean
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: ebfb-petname-path-only-sweep-4-gauntlet-clean
state: running
created_by: producer
created_at: 2026-09-30T13:02:28Z
---

# gauntlet ebfb-petname-path-only-sweep-4-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1390 (feature).
Posted by the completion edge of build `ebfb-petname-path-only-sweep-4`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
