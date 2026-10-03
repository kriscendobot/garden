---
withdrawn: true
withdrawn_reason: supervisor reviewed round-3 findings and the fix-3 head 9fbd5aa; all remaining correctness and powers/publish-security findings are resolved, local npm tests and the real book build pass, and the maintainer explicitly prefers skipping further low-value gauntlet rounds on this checkless book repo
withdrawn_by: orchestrator:garden-book-supervisor-20261003-retool
withdrawn_at: 2026-10-03T09:27:00Z
withdrawn_from: jobs/gauntlet
---

---
pr: https://github.com/kriscendobot/garden-book/pull/6
repo: kriscendobot/garden-book
pr_number: 6
build_job: book-build-js-retool
kind: feature
stage: fix
iteration: 3
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: book-build-js-retool-gauntlet-fix-3
state: running
created_by: producer
created_at: 2026-10-03T07:25:14Z
---

# gauntlet book-build-js-retool-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/garden-book/pull/6 (feature).
Posted by the completion edge of build `book-build-js-retool`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
