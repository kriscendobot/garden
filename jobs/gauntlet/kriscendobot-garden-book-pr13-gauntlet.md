---
pr: https://github.com/kriscendobot/garden-book/pull/13
repo: kriscendobot/garden-book
pr_number: 13
build_job: book-hyperlink-references-after-copyedit-20261004
kind: feature
stage: viability
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: 
state: pending
created_by: producer
created_at: 2026-10-13T17:37:32Z
---

# gauntlet kriscendobot-garden-book-pr13-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/garden-book/pull/13 (feature).
Posted by the completion edge of build `book-hyperlink-references-after-copyedit-20261004`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
