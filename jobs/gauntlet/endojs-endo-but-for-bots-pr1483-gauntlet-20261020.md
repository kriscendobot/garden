---
pr: https://github.com/endojs/endo-but-for-bots/pull/1483
repo: endojs/endo-but-for-bots
pr_number: 1483
build_job: 
kind: feature
stage: panel
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1483-gauntlet-20261020-panel-1
state: running
created_by: shepherd
arc: minion-town-mcp-ocapn
created_at: 2026-10-20T05:07:57Z
---

# gauntlet endojs-endo-but-for-bots-pr1483-gauntlet-20261020

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1483 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
