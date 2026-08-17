---
pr: https://github.com/endojs/endo-but-for-bots/pull/1024
repo: endojs/endo-but-for-bots
pr_number: 1024
build_job: groom-endo-stale-design-docs
kind: feature
stage: clean
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: endojs-endo-but-for-bots-pr1024-gauntlet-clean
state: running
created_by: producer
created_at: 2026-08-17T21:58:41Z
---

# gauntlet endojs-endo-but-for-bots-pr1024-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1024 (feature).
Posted by the completion edge of build `groom-endo-stale-design-docs`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
