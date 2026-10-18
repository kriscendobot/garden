---
pr: https://github.com/kriscendobot/minion.town/pull/206
repo: kriscendobot/minion.town
pr_number: 206
build_job: heal-minion-town-cfafabe
kind: feature
stage: viability
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: 
state: pending
created_by: fixer
created_at: 2026-10-18T13:26:14Z
---

# gauntlet kriscendobot-minion-town-pr206-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/206 (feature).
Posted by the completion edge of build `heal-minion-town-cfafabe`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
