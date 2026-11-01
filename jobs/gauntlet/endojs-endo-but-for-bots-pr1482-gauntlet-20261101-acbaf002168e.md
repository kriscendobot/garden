---
pr: https://github.com/endojs/endo-but-for-bots/pull/1482
repo: endojs/endo-but-for-bots
pr_number: 1482
build_job: 
kind: feature
stage: viability
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: 
state: pending
created_by: fixer
arc: minion-town-mcp-ocapn
created_at: 2026-11-01T23:36:42Z
---

# gauntlet endojs-endo-but-for-bots-pr1482-gauntlet-20261101-acbaf002168e

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1482 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
