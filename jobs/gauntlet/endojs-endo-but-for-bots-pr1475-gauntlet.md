---
pr: https://github.com/endojs/endo-but-for-bots/pull/1475
repo: endojs/endo-but-for-bots
pr_number: 1475
build_job: endo-but-for-bots-ocapn-noise-cryptographic-review-design
kind: feature
stage: viability
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1475-gauntlet-viability
state: running
created_by: producer
arc: endo-ocapn-background
created_at: 2026-10-16T17:56:46Z
---

# gauntlet endojs-endo-but-for-bots-pr1475-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1475 (feature).
Posted by the completion edge of build `endo-but-for-bots-ocapn-noise-cryptographic-review-design`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
