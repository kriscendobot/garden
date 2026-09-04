---
stage_retries: 0
pr: https://github.com/endojs/endo-but-for-bots/pull/1127
repo: endojs/endo-but-for-bots
pr_number: 1127
build_job: groom-carve-mcp-bridge-milestone
kind: feature
stage: panel
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: endojs-endo-but-for-bots-pr1127-gauntlet-panel-1
state: running
created_by: producer
created_at: 2026-09-03T21:21:09Z
---

# gauntlet endojs-endo-but-for-bots-pr1127-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1127 (feature).
Posted by the completion edge of build `groom-carve-mcp-bridge-milestone`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
