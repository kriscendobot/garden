---
pr: https://github.com/endojs/endo-but-for-bots/pull/1388
repo: endojs/endo-but-for-bots
pr_number: 1388
build_job: design-ebfb-ocapn-cloudflare-netlayer
kind: feature
stage: fix
iteration: 4
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1388-gauntlet-fix-4
state: running
created_by: producer
created_at: 2026-09-30T04:46:18Z
---

# gauntlet endojs-endo-but-for-bots-pr1388-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1388 (feature).
Posted by the completion edge of build `design-ebfb-ocapn-cloudflare-netlayer`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
