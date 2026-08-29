---
pr: https://github.com/kriscendobot/minion.town/pull/64
repo: kriscendobot/minion.town
pr_number: 64
build_job: endojs-endo-but-for-bots-pr1015-review-348a2017
kind: feature
stage: panel
iteration: 5
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: kriscendobot-minion.town-pr64-gauntlet-panel-5
state: running
created_by: producer
created_at: 2026-08-29T05:22:41Z
---

# gauntlet kriscendobot-minion.town-pr64-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/64 (feature).
Posted by the completion edge of build `endojs-endo-but-for-bots-pr1015-review-348a2017`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
