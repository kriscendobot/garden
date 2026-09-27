---
pr: https://github.com/endojs/endo-but-for-bots/pull/1298
repo: endojs/endo-but-for-bots
pr_number: 1298
build_job: ironhorse-fuzz-197b32cc30bdd4fe-repair
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
created_by: gardener
created_at: 2026-09-27T08:32:36Z
---

# gauntlet endojs-endo-but-for-bots-pr1298-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1298 (feature).
Posted by the completion edge of build `ironhorse-fuzz-197b32cc30bdd4fe-repair`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
