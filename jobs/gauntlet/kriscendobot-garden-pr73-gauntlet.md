---
stage_retries: 0
pr: https://github.com/kriscendobot/garden/pull/73
repo: kriscendobot/garden
pr_number: 73
build_job: kriscendobot-garden-pr73-review-6e23fb68
kind: feature
stage: undraft
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: kriscendobot-garden-pr73-gauntlet-undraft
state: running
created_by: producer
created_at: 2026-09-03T21:23:55Z
---

# gauntlet kriscendobot-garden-pr73-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/garden/pull/73 (feature).
Posted by the completion edge of build `kriscendobot-garden-pr73-review-6e23fb68`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
