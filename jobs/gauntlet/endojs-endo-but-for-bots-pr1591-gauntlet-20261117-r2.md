---
pr: https://github.com/endojs/endo-but-for-bots/pull/1591
repo: endojs/endo-but-for-bots
pr_number: 1591
build_job: 
kind: feature
stage: viability
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 3
current_child: endojs-endo-but-for-bots-pr1591-gauntlet-20261117-r2-viability
state: running
created_by: gardener
created_at: 2026-11-17T11:01:26Z
---

# gauntlet endojs-endo-but-for-bots-pr1591-gauntlet-20261117-r2

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1591 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
