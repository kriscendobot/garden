---
pr: https://github.com/endojs/endo-but-for-bots/pull/888
repo: endojs/endo-but-for-bots
pr_number: 888
build_job: registry-immutable-byte-array-followup
kind: feature
stage: clean
iteration: 0
max_iterations: 6
current_child: 
state: pending
created_by: producer
created_at: 2026-07-29T17:48:56Z
---

# gauntlet registry-immutable-byte-array-followup-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/888 (feature).
Posted by the completion edge of build `registry-immutable-byte-array-followup`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
