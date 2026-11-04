---
panel_head: bc96608738f2b961ccc6a576f6de927b04e44a78
pr: https://github.com/kriscendobot/garden-book/pull/17
repo: kriscendobot/garden-book
pr_number: 17
build_job: build-minion-town-tool-removal-20261104
kind: feature
stage: panel
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: kriscendobot-garden-book-pr17-gauntlet-panel-1
state: running
created_by: producer
created_at: 2026-11-04T04:16:32Z
---

# gauntlet kriscendobot-garden-book-pr17-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/garden-book/pull/17 (feature).
Posted by the completion edge of build `build-minion-town-tool-removal-20261104`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
