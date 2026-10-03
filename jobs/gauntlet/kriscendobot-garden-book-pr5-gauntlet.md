---
pr: https://github.com/kriscendobot/garden-book/pull/5
repo: kriscendobot/garden-book
pr_number: 5
build_job: book-illustrations-integrate-after-pr4
kind: feature
stage: viability
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: kriscendobot-garden-book-pr5-gauntlet-viability
state: running
created_by: producer
created_at: 2026-10-03T06:25:24Z
---

# gauntlet kriscendobot-garden-book-pr5-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/garden-book/pull/5 (feature).
Posted by the completion edge of build `book-illustrations-integrate-after-pr4`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
