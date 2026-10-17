---
panel_head: 9c98898f97d32926edd1c71225ed4d53ba78f1e0
pr: https://github.com/kriscendobot/garden-book/pull/16
repo: kriscendobot/garden-book
pr_number: 16
build_job: garden-book-colophon-20261016
kind: feature
stage: panel
iteration: 2
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: kriscendobot-garden-book-pr16-gauntlet-panel-2
state: running
created_by: producer
arc: garden-book
created_at: 2026-10-17T00:46:06Z
---

# gauntlet kriscendobot-garden-book-pr16-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/garden-book/pull/16 (feature).
Posted by the completion edge of build `garden-book-colophon-20261016`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
