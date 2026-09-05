---
pr: https://github.com/kriscendobot/minion.town/pull/95
repo: kriscendobot/minion.town
pr_number: 95
build_job: minion-town-eval-synthesis
kind: feature
stage: fix
iteration: 2
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: kriscendobot-minion.town-pr95-gauntlet-fix-2
state: running
created_by: producer
created_at: 2026-09-05T15:01:01Z
---

# gauntlet kriscendobot-minion.town-pr95-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/95 (feature).
Posted by the completion edge of build `minion-town-eval-synthesis`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
