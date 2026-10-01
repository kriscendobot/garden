---
pr: https://github.com/endojs/endo-but-for-bots/pull/1410
repo: endojs/endo-but-for-bots
pr_number: 1410
build_job: ebfb-guest-designation-consumers
kind: feature
stage: clean
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: ebfb-guest-designation-consumers-gauntlet-clean
state: running
created_by: producer
created_at: 2026-10-01T11:49:33Z
---

# gauntlet ebfb-guest-designation-consumers-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1410 (feature).
Posted by the completion edge of build `ebfb-guest-designation-consumers`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
