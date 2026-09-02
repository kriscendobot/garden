---
pr: https://github.com/kriscendobot/minion.town/pull/79
repo: kriscendobot/minion.town
pr_number: 79
build_job: build-minion-town-pr77-tool-name-reconciliation-review5083753201
kind: feature
stage: fix
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: build-minion-town-pr77-tool-name-reconciliation-review5083753201-gauntlet-fix-1
state: running
created_by: producer
created_at: 2026-09-01T23:11:34Z
---

# gauntlet build-minion-town-pr77-tool-name-reconciliation-review5083753201-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/79 (feature).
Posted by the completion edge of build `build-minion-town-pr77-tool-name-reconciliation-review5083753201`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
