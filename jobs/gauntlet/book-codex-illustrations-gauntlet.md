---
pr: https://github.com/kriscendobot/garden-book/pull/4
repo: kriscendobot/garden-book
pr_number: 4
build_job: book-codex-illustrations
kind: feature
stage: viability
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: book-codex-illustrations-gauntlet-viability
state: running
created_by: producer
created_at: 2026-10-03T06:05:11Z
---

# gauntlet book-codex-illustrations-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/garden-book/pull/4 (feature).
Posted by the completion edge of build `book-codex-illustrations`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
