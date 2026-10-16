---
pr: https://github.com/endojs/endo-but-for-bots/pull/1392
repo: endojs/endo-but-for-bots
pr_number: 1392
build_job: parcel-pivot-stack-20261014
kind: probe
stage: panel
iteration: 6
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 2
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1392-gauntlet-panel-6
state: running
created_by: gardener
created_at: 2026-10-15T00:26:43Z
---

# gauntlet endojs-endo-but-for-bots-pr1392-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1392 (probe).
Posted by the completion edge of build `parcel-pivot-stack-20261014`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
