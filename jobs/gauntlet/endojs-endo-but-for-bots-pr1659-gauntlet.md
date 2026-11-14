---
panel_head: 7c100929afcbd42998a471be29e190e397f43440
pr: https://github.com/endojs/endo-but-for-bots/pull/1659
repo: endojs/endo-but-for-bots
pr_number: 1659
build_job: fix-endo-zizmor-create-pull-request-v8-comment
kind: feature
stage: panel
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1659-gauntlet-panel-1
state: running
created_by: producer
created_at: 2026-11-14T06:51:24Z
---

# gauntlet endojs-endo-but-for-bots-pr1659-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1659 (feature).
Posted by the completion edge of build `fix-endo-zizmor-create-pull-request-v8-comment`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
