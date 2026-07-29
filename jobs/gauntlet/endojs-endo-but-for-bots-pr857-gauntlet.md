---
pr: https://github.com/endojs/endo-but-for-bots/pull/857
repo: endojs/endo-but-for-bots
pr_number: 857
build_job: 
kind: feature
stage: clean
iteration: 0
max_iterations: 6
current_child: endojs-endo-but-for-bots-pr857-gauntlet-clean
state: running
created_by: comment-watcher
created_at: 2026-07-29T23:50:24Z
---

# gauntlet endojs-endo-but-for-bots-pr857-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/857 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
