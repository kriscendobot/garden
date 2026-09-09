---
pr: https://github.com/kriscendobot/minion.town/pull/99
repo: kriscendobot/minion.town
pr_number: 99
build_job: build-minion-town-claude-harness-provisioning
kind: feature
stage: fix
iteration: 4
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: build-minion-town-claude-harness-provisioning-gauntlet-fix-4
state: running
created_by: producer
created_at: 2026-09-08T23:10:08Z
---

# gauntlet build-minion-town-claude-harness-provisioning-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/99 (feature).
Posted by the completion edge of build `build-minion-town-claude-harness-provisioning`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
