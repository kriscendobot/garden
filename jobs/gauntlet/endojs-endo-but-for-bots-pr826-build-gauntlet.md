---
pr: https://github.com/endojs/endo-but-for-bots/pull/910
repo: endojs/endo-but-for-bots
pr_number: 910
build_job: endojs-endo-but-for-bots-pr826-build
kind: feature
stage: panel
iteration: 1
max_iterations: 6
current_child: endojs-endo-but-for-bots-pr826-build-gauntlet-panel-1
state: running
created_by: producer
created_at: 2026-08-01T19:54:51Z
---

# gauntlet endojs-endo-but-for-bots-pr826-build-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/910 (feature).
Posted by the completion edge of build `endojs-endo-but-for-bots-pr826-build`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
