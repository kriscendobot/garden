---
pr: https://github.com/kriscendobot/minion.town/pull/63
repo: kriscendobot/minion.town
pr_number: 63
build_job: minion-town-press-20260828-173506
kind: feature
stage: panel
iteration: 4
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: kriscendobot-minion.town-pr63-gauntlet-panel-4
state: running
created_by: producer
created_at: 2026-08-28T17:43:22Z
---

# gauntlet kriscendobot-minion.town-pr63-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/63 (feature).
Posted by the completion edge of build `minion-town-press-20260828-173506`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
