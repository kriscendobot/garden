---
pr: https://github.com/endojs/endo-but-for-bots/pull/1430
repo: endojs/endo-but-for-bots
pr_number: 1430
build_job: design-ocapn-tcp-for-test-extraction-revision
kind: feature
stage: clean
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1430-gauntlet-clean
state: running
created_by: producer
arc: endo-ocapn-background
created_at: 2026-10-07T14:52:44Z
---

# gauntlet endojs-endo-but-for-bots-pr1430-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1430 (feature).
Posted by the completion edge of build `design-ocapn-tcp-for-test-extraction-revision`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
