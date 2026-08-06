---
pr: https://github.com/endojs/endo-but-for-bots/pull/943
repo: endojs/endo-but-for-bots
pr_number: 943
build_job: build-endo-ascii
kind: feature
stage: clean
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: build-endo-ascii-gauntlet-clean
state: running
created_by: producer
created_at: 2026-08-06T14:52:36Z
---

# gauntlet build-endo-ascii-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/943 (feature).
Posted by the completion edge of build `build-endo-ascii`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
