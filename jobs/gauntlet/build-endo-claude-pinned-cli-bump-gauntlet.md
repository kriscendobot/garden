---
pr: https://github.com/endojs/endo-but-for-bots/pull/1406
repo: endojs/endo-but-for-bots
pr_number: 1406
build_job: build-endo-claude-pinned-cli-bump
kind: feature
stage: fix
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: build-endo-claude-pinned-cli-bump-gauntlet-fix-1
state: running
created_by: producer
created_at: 2026-10-01T09:16:38Z
---

# gauntlet build-endo-claude-pinned-cli-bump-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1406 (feature).
Posted by the completion edge of build `build-endo-claude-pinned-cli-bump`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
