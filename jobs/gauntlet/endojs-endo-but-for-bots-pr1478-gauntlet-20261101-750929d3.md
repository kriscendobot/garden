---
pr: https://github.com/endojs/endo-but-for-bots/pull/1478
repo: endojs/endo-but-for-bots
pr_number: 1478
build_job: 
kind: feature
stage: viability
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1478-gauntlet-20261101-750929d3-viability
state: running
created_by: fixer
arc: minion-town-mcp-ocapn
created_at: 2026-11-01T19:38:33Z
---

# gauntlet endojs-endo-but-for-bots-pr1478-gauntlet-20261101-750929d3

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1478 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
