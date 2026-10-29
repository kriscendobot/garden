---
pr: https://github.com/endojs/endo-but-for-bots/pull/1576
repo: endojs/endo-but-for-bots
pr_number: 1576
build_job: 
kind: feature
stage: clean
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1576-gauntlet-02dbd31-clean
state: running
created_by: gardener
created_at: 2026-10-29T09:42:25Z
---

# gauntlet endojs-endo-but-for-bots-pr1576-gauntlet-02dbd31

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1576 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
