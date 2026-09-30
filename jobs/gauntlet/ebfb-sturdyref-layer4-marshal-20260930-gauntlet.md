---
pr: https://github.com/endojs/endo-but-for-bots/pull/1393
repo: endojs/endo-but-for-bots
pr_number: 1393
build_job: ebfb-sturdyref-layer4-marshal-20260930
kind: feature
stage: clean
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: ebfb-sturdyref-layer4-marshal-20260930-gauntlet-clean
state: running
created_by: producer
created_at: 2026-09-30T07:09:00Z
---

# gauntlet ebfb-sturdyref-layer4-marshal-20260930-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1393 (feature).
Posted by the completion edge of build `ebfb-sturdyref-layer4-marshal-20260930`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
