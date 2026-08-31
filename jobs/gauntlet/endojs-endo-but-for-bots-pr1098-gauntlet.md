---
pr: https://github.com/endojs/endo-but-for-bots/pull/1098
repo: endojs/endo-but-for-bots
pr_number: 1098
build_job: endojs-endo-but-for-bots-endo-claude-sibling-notes-20260831
kind: feature
stage: panel
iteration: 4
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: endojs-endo-but-for-bots-pr1098-gauntlet-panel-4
state: running
created_by: producer
created_at: 2026-08-31T09:40:06Z
---

# gauntlet endojs-endo-but-for-bots-pr1098-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1098 (feature).
Posted by the completion edge of build `endojs-endo-but-for-bots-endo-claude-sibling-notes-20260831`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
