---
pr: https://github.com/endojs/endo-but-for-bots/pull/1298
repo: endojs/endo-but-for-bots
pr_number: 1298
build_job: 
kind: feature
stage: viability
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1298-gauntlet-r2-viability
state: running
created_by: ironhorse-fuzz-27824c75429b8581-repair
created_at: 2026-09-28T05:20:19Z
---

# gauntlet endojs-endo-but-for-bots-pr1298-gauntlet-r2

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1298 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
