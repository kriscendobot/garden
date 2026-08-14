---
pr: https://github.com/endojs/endo-but-for-bots/pull/988
repo: endojs/endo-but-for-bots
pr_number: 988
build_job: ebfb-daemon-commit-formula-design
kind: feature
stage: panel
iteration: 2
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: endojs-endo-but-for-bots-pr988-gauntlet-panel-2
state: running
created_by: producer
created_at: 2026-08-14T20:55:05Z
---

# gauntlet endojs-endo-but-for-bots-pr988-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/988 (feature).
Posted by the completion edge of build `ebfb-daemon-commit-formula-design`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
