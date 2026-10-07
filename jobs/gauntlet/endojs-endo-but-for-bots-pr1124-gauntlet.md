---
pr: https://github.com/endojs/endo-but-for-bots/pull/1124
repo: endojs/endo-but-for-bots
pr_number: 1124
build_job: endojs-endo-but-for-bots-pr1124-weave-20261007
kind: feature
stage: panel
iteration: 5
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1124-gauntlet-panel-5
state: running
created_by: producer
arc: minion-town-mcp-ocapn
created_at: 2026-10-07T14:32:40Z
---

# gauntlet endojs-endo-but-for-bots-pr1124-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1124 (feature).
Posted by the completion edge of build `endojs-endo-but-for-bots-pr1124-weave-20261007`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
