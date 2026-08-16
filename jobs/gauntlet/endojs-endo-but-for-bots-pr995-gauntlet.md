---
pr: https://github.com/endojs/endo-but-for-bots/pull/995
repo: endojs/endo-but-for-bots
pr_number: 995
build_job: design-endo-claude
kind: feature
stage: panel
iteration: 2
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: endojs-endo-but-for-bots-pr995-gauntlet-panel-2
state: running
created_by: producer
created_at: 2026-08-16T05:57:57Z
---

# gauntlet endojs-endo-but-for-bots-pr995-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/995 (feature).
Posted by the completion edge of build `design-endo-claude`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
