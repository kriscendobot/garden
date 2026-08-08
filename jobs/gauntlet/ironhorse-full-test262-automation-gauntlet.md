---
pr: https://github.com/endojs/endo-but-for-bots/pull/969
repo: endojs/endo-but-for-bots
pr_number: 969
build_job: ironhorse-full-test262-automation
kind: feature
stage: panel
iteration: 6
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: ironhorse-full-test262-automation-gauntlet-panel-6
state: running
created_by: producer
created_at: 2026-08-08T04:12:53Z
---

# gauntlet ironhorse-full-test262-automation-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/969 (feature).
Posted by the completion edge of build `ironhorse-full-test262-automation`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
