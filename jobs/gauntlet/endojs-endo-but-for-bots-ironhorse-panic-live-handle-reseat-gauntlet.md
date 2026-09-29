---
pr: https://github.com/endojs/endo-but-for-bots/pull/1380
repo: endojs/endo-but-for-bots
pr_number: 1380
build_job: endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat
kind: feature
stage: viability
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet-viability
state: running
created_by: producer
created_at: 2026-09-29T18:34:00Z
---

# gauntlet endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1380 (feature).
Posted by the completion edge of build `endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
