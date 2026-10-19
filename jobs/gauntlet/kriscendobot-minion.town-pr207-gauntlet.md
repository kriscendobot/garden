---
pr: https://github.com/kriscendobot/minion.town/pull/207
repo: kriscendobot/minion.town
pr_number: 207
build_job: fix-minion-town-browser-gate-firefox-storage-main
kind: feature
stage: panel
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: kriscendobot-minion.town-pr207-gauntlet-panel-1
state: running
created_by: producer
created_at: 2026-10-19T06:27:17Z
---

# gauntlet kriscendobot-minion.town-pr207-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/207 (feature).
Posted by the completion edge of build `fix-minion-town-browser-gate-firefox-storage-main`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
