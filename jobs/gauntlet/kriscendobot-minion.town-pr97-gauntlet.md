---
pr: https://github.com/kriscendobot/minion.town/pull/97
repo: kriscendobot/minion.town
pr_number: 97
build_job: design-minion-town-claude-agents-root-endowment
kind: feature
stage: clean
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: 
state: pending
created_by: producer
created_at: 2026-09-08T19:05:52Z
---

# gauntlet kriscendobot-minion.town-pr97-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/97 (feature).
Posted by the completion edge of build `design-minion-town-claude-agents-root-endowment`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
