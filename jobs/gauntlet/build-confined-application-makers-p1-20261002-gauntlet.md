---
pr: https://github.com/endojs/endo-but-for-bots/pull/1417
repo: endojs/endo-but-for-bots
pr_number: 1417
build_job: build-confined-application-makers-p1-20261002
kind: feature
stage: viability
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: build-confined-application-makers-p1-20261002-gauntlet-viability
state: running
created_by: producer
created_at: 2026-10-02T17:01:21Z
---

# gauntlet build-confined-application-makers-p1-20261002-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1417 (feature).
Posted by the completion edge of build `build-confined-application-makers-p1-20261002`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
