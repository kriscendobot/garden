---
pr: https://github.com/endojs/endo-but-for-bots/pull/977
repo: endojs/endo-but-for-bots
pr_number: 977
build_job: ebfb-guest-unconfined-from-tree
kind: feature
stage: panel
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: ebfb-guest-unconfined-from-tree-gauntlet-panel-1
state: running
created_by: producer
created_at: 2026-08-13T02:55:31Z
---

# gauntlet ebfb-guest-unconfined-from-tree-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/977 (feature).
Posted by the completion edge of build `ebfb-guest-unconfined-from-tree`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
