---
panel_head: e8294ede88ecfdde246386d42c8071e606da828a
pr: https://github.com/endojs/endo-but-for-bots/pull/1567
repo: endojs/endo-but-for-bots
pr_number: 1567
build_job: 
kind: feature
stage: undraft
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1567-gauntlet-undraft
state: running
created_by: design-pr-gauntlet-coverage-audit
created_at: 2026-10-26T09:32:34Z
---

# gauntlet endojs-endo-but-for-bots-pr1567-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1567 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
