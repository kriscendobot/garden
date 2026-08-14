---
pr: https://github.com/kriscendobot/minion.town/pull/41
repo: kriscendobot/minion.town
pr_number: 41
build_job: 
kind: feature
stage: clean
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: 
state: pending
created_by: fixer
created_at: 2026-08-14T06:12:10Z
---

# gauntlet kriscendobot-minion.town-pr41-gauntlet-after-fix-1

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/41 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
