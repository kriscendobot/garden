---
pr: https://github.com/endojs/endo-but-for-bots/pull/1675
repo: endojs/endo-but-for-bots
pr_number: 1675
build_job: build-endopi-extension-package-manifest-prerequisite-check
kind: feature
stage: viability
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1675-gauntlet-viability
state: running
created_by: producer
arc: endo-ocapn-background
created_at: 2026-11-17T23:55:19Z
---

# gauntlet endojs-endo-but-for-bots-pr1675-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1675 (feature).
Posted by the completion edge of build `build-endopi-extension-package-manifest-prerequisite-check`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
