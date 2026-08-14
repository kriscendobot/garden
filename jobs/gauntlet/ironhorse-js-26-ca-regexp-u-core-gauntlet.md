---
pr: https://github.com/endojs/endo-but-for-bots/pull/970
repo: endojs/endo-but-for-bots
pr_number: 970
build_job: ironhorse-js-26-ca-regexp-u-core
kind: feature
stage: clean
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: ironhorse-js-26-ca-regexp-u-core-gauntlet-clean
state: running
created_by: producer
created_at: 2026-08-14T22:52:03Z
---

# gauntlet ironhorse-js-26-ca-regexp-u-core-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/970 (feature).
Posted by the completion edge of build `ironhorse-js-26-ca-regexp-u-core`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
