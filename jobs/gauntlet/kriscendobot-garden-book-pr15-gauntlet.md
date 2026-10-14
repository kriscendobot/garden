---
pr: https://github.com/kriscendobot/garden-book/pull/15
repo: kriscendobot/garden-book
pr_number: 15
build_job: garden-book-illuminations-republish-20261014
kind: feature
stage: panel
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: kriscendobot-garden-book-pr15-gauntlet-panel-1
state: running
created_by: producer
arc: garden-book
created_at: 2026-10-14T04:07:45Z
---

# gauntlet kriscendobot-garden-book-pr15-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/garden-book/pull/15 (feature).
Posted by the completion edge of build `garden-book-illuminations-republish-20261014`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
