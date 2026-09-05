---
pr: https://github.com/kriscendobot/minion.town/pull/58
repo: kriscendobot/minion.town
pr_number: 58
build_job: 
kind: feature
stage: clean
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: kriscendobot-minion.town-pr58-gauntlet-clean
state: running
created_by: comment-watcher
created_at: 2026-09-05T01:08:11Z
---

# gauntlet kriscendobot-minion.town-pr58-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/58 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
