---
panel_head: 2866a26dbfe791e9a0ed771d52ad727e826d32da
pr: https://github.com/endojs/endo-but-for-bots/pull/1543
repo: endojs/endo-but-for-bots
pr_number: 1543
build_job: endojs-endo-but-for-bots-pr1543-gauntlet-20261031
kind: feature
stage: undraft
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1543-rereview-20261031-2866a26dbfe7-gauntlet-undraft
state: running
created_by: shepherd
arc: minion-town-claude-api
created_at: 2026-10-31T09:47:45Z
---

# gauntlet endojs-endo-but-for-bots-pr1543-rereview-20261031-2866a26dbfe7-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1543 (feature).
Posted by the completion edge of build `endojs-endo-but-for-bots-pr1543-gauntlet-20261031`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
