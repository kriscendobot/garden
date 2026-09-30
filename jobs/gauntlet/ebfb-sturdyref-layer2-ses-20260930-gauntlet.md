---
pr: https://github.com/endojs/endo-but-for-bots/pull/1391
repo: endojs/endo-but-for-bots
pr_number: 1391
build_job: ebfb-sturdyref-layer2-ses-20260930
kind: feature
stage: panel
iteration: 3
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: ebfb-sturdyref-layer2-ses-20260930-gauntlet-panel-3
state: running
created_by: producer
created_at: 2026-09-30T06:19:17Z
---

# gauntlet ebfb-sturdyref-layer2-ses-20260930-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1391 (feature).
Posted by the completion edge of build `ebfb-sturdyref-layer2-ses-20260930`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
