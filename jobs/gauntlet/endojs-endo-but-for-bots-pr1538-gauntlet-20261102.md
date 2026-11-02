---
pr: https://github.com/endojs/endo-but-for-bots/pull/1538
repo: endojs/endo-but-for-bots
pr_number: 1538
build_job: 
kind: feature
stage: panel
iteration: 3
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1538-gauntlet-20261102-panel-3
state: running
created_by: gardener
arc: minion-town-git-remote
created_at: 2026-11-02T00:32:04Z
---

# gauntlet endojs-endo-but-for-bots-pr1538-gauntlet-20261102

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1538 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
