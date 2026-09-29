---
pr: https://github.com/endojs/endo-but-for-bots/pull/1379
repo: endojs/endo-but-for-bots
pr_number: 1379
build_job: endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr
kind: feature
stage: viability
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet-viability
state: running
created_by: producer
created_at: 2026-09-29T18:13:56Z
---

# gauntlet endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1379 (feature).
Posted by the completion edge of build `endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
