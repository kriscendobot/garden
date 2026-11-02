---
pr: https://github.com/endojs/endo-but-for-bots/pull/667
repo: endojs/endo-but-for-bots
pr_number: 667
build_job: 
kind: feature
stage: fix
iteration: 3
max_iterations: 6
resumes: 1
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr667-gauntlet-20261102-7e7e4481b830-fix-3
state: running
created_by: fixer
arc: minion-town-mcp-ocapn
created_at: 2026-11-02T00:34:43Z
---

# gauntlet endojs-endo-but-for-bots-pr667-gauntlet-20261102-7e7e4481b830

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/667 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
