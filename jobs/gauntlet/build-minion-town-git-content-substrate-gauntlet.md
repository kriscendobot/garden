---
pr: https://github.com/kriscendobot/minion.town/pull/48
repo: kriscendobot/minion.town
pr_number: 48
build_job: build-minion-town-git-content-substrate
kind: feature
stage: panel
iteration: 5
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: build-minion-town-git-content-substrate-gauntlet-panel-5
state: running
created_by: producer
created_at: 2026-08-18T00:40:52Z
---

# gauntlet build-minion-town-git-content-substrate-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/48 (feature).
Posted by the completion edge of build `build-minion-town-git-content-substrate`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
