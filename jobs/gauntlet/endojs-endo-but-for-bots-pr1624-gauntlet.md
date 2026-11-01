---
pr: https://github.com/endojs/endo-but-for-bots/pull/1624
repo: endojs/endo-but-for-bots
pr_number: 1624
build_job: build-ironhorse-in-crank-string-garbage-chunk-ceiling
kind: feature
stage: viability
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1624-gauntlet-viability
state: running
created_by: producer
arc: ironhorse-test262-ratchet
created_at: 2026-11-01T17:59:31Z
---

# gauntlet endojs-endo-but-for-bots-pr1624-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1624 (feature).
Posted by the completion edge of build `build-ironhorse-in-crank-string-garbage-chunk-ceiling`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
