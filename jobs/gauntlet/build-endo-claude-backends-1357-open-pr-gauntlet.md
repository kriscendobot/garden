---
pr: https://github.com/endojs/endo-but-for-bots/pull/1412
repo: endojs/endo-but-for-bots
pr_number: 1412
build_job: build-endo-claude-backends-1357-open-pr
kind: feature
stage: clean
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: build-endo-claude-backends-1357-open-pr-gauntlet-clean
state: running
created_by: producer
created_at: 2026-10-01T18:53:38Z
---

# gauntlet build-endo-claude-backends-1357-open-pr-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1412 (feature).
Posted by the completion edge of build `build-endo-claude-backends-1357-open-pr`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
