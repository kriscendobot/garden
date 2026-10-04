---
pr: https://github.com/kriscendobot/minion.town/pull/157
repo: kriscendobot/minion.town
pr_number: 157
build_job: build-minion-town-claude-account-html-page
kind: feature
stage: fix
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: build-minion-town-claude-account-html-page-gauntlet-fix-1
state: running
created_by: producer
created_at: 2026-10-04T23:01:16Z
---

# gauntlet build-minion-town-claude-account-html-page-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/157 (feature).
Posted by the completion edge of build `build-minion-town-claude-account-html-page`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
