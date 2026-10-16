---
panel_head: a908c2902afa3bb730f7e4fa76100bbefad1600d
pr: https://github.com/endojs/endo-but-for-bots/pull/1484
repo: endojs/endo-but-for-bots
pr_number: 1484
build_job: design-https-fragment-locators-20261016
kind: feature
stage: undraft
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1484-gauntlet-undraft
state: running
created_by: producer
created_at: 2026-10-16T22:06:15Z
---

# gauntlet endojs-endo-but-for-bots-pr1484-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1484 (feature).
Posted by the completion edge of build `design-https-fragment-locators-20261016`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
