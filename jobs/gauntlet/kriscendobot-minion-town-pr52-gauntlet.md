---
pr: https://github.com/kriscendobot/minion.town/pull/52
repo: kriscendobot/minion.town
pr_number: 52
build_job: build-minion-town-sites-exo-20260823
kind: feature
stage: fix
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: kriscendobot-minion-town-pr52-gauntlet-fix-1
state: running
created_by: producer
created_at: 2026-08-24T01:08:06Z
---

# gauntlet kriscendobot-minion-town-pr52-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/52 (feature).
Posted by the completion edge of build `build-minion-town-sites-exo-20260823`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
