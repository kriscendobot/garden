---
pr: https://github.com/endojs/endo-but-for-bots/pull/282
repo: endojs/endo-but-for-bots
pr_number: 282
build_job: endor-host-hook-surface-20260827
kind: feature
stage: clean
iteration: 0
max_iterations: 6
resumes: 1
max_resumes: 6
current_child: endor-host-hook-surface-20260827-gauntlet-clean
state: running
created_by: producer
created_at: 2026-08-27T10:20:47Z
---

# gauntlet endor-host-hook-surface-20260827-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/282 (feature).
Posted by the completion edge of build `endor-host-hook-surface-20260827`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
