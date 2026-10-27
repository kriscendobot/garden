---
panel_head: 4c315e84c021efcf6e0a20f3cb3bb5fac0deca5b
pr: https://github.com/endojs/endo-but-for-bots/pull/1349
repo: endojs/endo-but-for-bots
pr_number: 1349
build_job: 
kind: feature
stage: undraft
iteration: 3
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1349-gauntlet-20261027-undraft
state: running
created_by: gardener
created_at: 2026-10-27T11:01:51Z
---

# gauntlet endojs-endo-but-for-bots-pr1349-gauntlet-20261027

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1349 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
