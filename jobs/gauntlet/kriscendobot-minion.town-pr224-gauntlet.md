---
panel_head: c2b969fc36ea3a79928a057738cf1d1e18feeb74
pr: https://github.com/kriscendobot/minion.town/pull/224
repo: kriscendobot/minion.town
pr_number: 224
build_job: heal-minion-town-prod-probe-red-c104813
kind: feature
stage: panel
iteration: 3
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: kriscendobot-minion.town-pr224-gauntlet-panel-3
state: running
created_by: producer
created_at: 2026-10-25T00:59:54Z
---

# gauntlet kriscendobot-minion.town-pr224-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/224 (feature).
Posted by the completion edge of build `heal-minion-town-prod-probe-red-c104813`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
