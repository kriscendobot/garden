---
pr: https://github.com/endojs/endo-but-for-bots/pull/1359
repo: endojs/endo-but-for-bots
pr_number: 1359
build_job: verify-ironhorse-press-first-engagement-20260929
kind: feature
stage: viability
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: 
state: pending
created_by: producer
created_at: 2026-10-30T03:24:07Z
---

# gauntlet endojs-endo-but-for-bots-pr1359-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1359 (feature).
Posted by the completion edge of build `verify-ironhorse-press-first-engagement-20260929`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
