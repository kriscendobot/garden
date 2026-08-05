---
pr: https://github.com/kriscendobot/minion.town/pull/24
repo: kriscendobot/minion.town
pr_number: 24
build_job: minion-town-ocapn-runahead-pin
kind: feature
stage: clean
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: minion-town-ocapn-runahead-pin-gauntlet-clean
state: running
created_by: producer
created_at: 2026-08-05T15:06:17Z
---

# gauntlet minion-town-ocapn-runahead-pin-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/24 (feature).
Posted by the completion edge of build `minion-town-ocapn-runahead-pin`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
