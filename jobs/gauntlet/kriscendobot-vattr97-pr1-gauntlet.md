---
pr: https://github.com/kriscendobot/vattr97/pull/1
repo: kriscendobot/vattr97
pr_number: 1
build_job: 
kind: feature
stage: clean
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: kriscendobot-vattr97-pr1-gauntlet-clean
state: running
created_by: design-pr-gauntlet-coverage-audit
created_at: 2026-08-30T07:40:10Z
---

# gauntlet kriscendobot-vattr97-pr1-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/vattr97/pull/1 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
