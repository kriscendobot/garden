---
pr: https://github.com/endojs/endo-but-for-bots/pull/871
repo: endojs/endo-but-for-bots
pr_number: 871
build_job: 
kind: feature
stage: viability
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr871-gauntlet-20260901-viability
state: running
created_by: endo-sturdyref-agent-surface-gauntlet-20260901
created_at: 2026-09-27T05:12:47Z
---

# gauntlet endojs-endo-but-for-bots-pr871-gauntlet-20260901

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/871 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
