---
pr: https://github.com/endojs/endo-but-for-bots/pull/1640
repo: endojs/endo-but-for-bots
pr_number: 1640
build_job: endopi-prompt-templates-open-pr
kind: feature
stage: clean
iteration: 0
max_iterations: 6
resumes: 1
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1640-gauntlet-clean
state: running
created_by: producer
arc: moonshots
created_at: 2026-11-03T02:01:21Z
---

# gauntlet endojs-endo-but-for-bots-pr1640-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1640 (feature).
Posted by the completion edge of build `endopi-prompt-templates-open-pr`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
