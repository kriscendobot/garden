---
pr: https://github.com/endojs/endo-but-for-bots/pull/1560
repo: endojs/endo-but-for-bots
pr_number: 1560
build_job: build-endo-claude-agents-capability-20261026
kind: feature
stage: clean
iteration: 0
max_iterations: 6
resumes: 1
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1560-gauntlet-clean
state: running
created_by: producer
arc: minion-town-mcp-ocapn
created_at: 2026-10-26T02:10:30Z
---

# gauntlet endojs-endo-but-for-bots-pr1560-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1560 (feature).
Posted by the completion edge of build `build-endo-claude-agents-capability-20261026`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
