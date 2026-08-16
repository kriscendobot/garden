---
pr: https://github.com/endojs/endo-but-for-bots/pull/997
repo: endojs/endo-but-for-bots
pr_number: 997
build_job: ebfb-worker-retention-design
kind: feature
stage: fix
iteration: 5
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: endojs-endo-but-for-bots-pr997-gauntlet-fix-5
state: running
created_by: producer
created_at: 2026-08-16T07:47:48Z
---

# gauntlet endojs-endo-but-for-bots-pr997-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/997 (feature).
Posted by the completion edge of build `ebfb-worker-retention-design`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
