---
pr: https://github.com/endojs/endo-but-for-bots/pull/1617
repo: endojs/endo-but-for-bots
pr_number: 1617
build_job: ironhorse-test262-ratchet-coverage-crank-tenth-slice-20261101-open-pr
kind: feature
stage: viability
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1617-gauntlet-viability
state: running
created_by: producer
arc: ironhorse-test262-ratchet
created_at: 2026-11-01T15:01:47Z
---

# gauntlet endojs-endo-but-for-bots-pr1617-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1617 (feature).
Posted by the completion edge of build `ironhorse-test262-ratchet-coverage-crank-tenth-slice-20261101-open-pr`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
