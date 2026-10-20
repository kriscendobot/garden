---
pr: https://github.com/endojs/endo-but-for-bots/pull/1478
repo: endojs/endo-but-for-bots
pr_number: 1478
build_job: 
kind: feature
stage: panel
iteration: 2
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 1
max_stage_retries: 2
current_child: endo-but-for-bots-pr1478-gauntlet-panel-2
state: running
created_by: shepherd
arc: minion-town-mcp-ocapn
created_at: 2026-10-19T22:51:41Z
---

# gauntlet endo-but-for-bots-pr1478-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1478 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
