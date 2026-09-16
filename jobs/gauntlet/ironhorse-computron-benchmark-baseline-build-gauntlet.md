---
pr: https://github.com/endojs/endo-but-for-bots/pull/1283
repo: endojs/endo-but-for-bots
pr_number: 1283
build_job: ironhorse-computron-benchmark-baseline-build
kind: feature
stage: fix
iteration: 6
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: ironhorse-computron-benchmark-baseline-build-gauntlet-fix-6
state: running
created_by: producer
created_at: 2026-09-16T05:40:57Z
---

# gauntlet ironhorse-computron-benchmark-baseline-build-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1283 (feature).
Posted by the completion edge of build `ironhorse-computron-benchmark-baseline-build`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
