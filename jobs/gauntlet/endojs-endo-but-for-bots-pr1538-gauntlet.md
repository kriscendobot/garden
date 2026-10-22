---
pr: https://github.com/endojs/endo-but-for-bots/pull/1538
repo: endojs/endo-but-for-bots
pr_number: 1538
build_job: fu-design-daemon-git-clone-provide-git-clone-bootstrap-1-open-pr
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
arc: daemon-git
created_at: 2026-10-22T17:23:30Z
---

# gauntlet endojs-endo-but-for-bots-pr1538-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1538 (feature).
Posted by the completion edge of build `fu-design-daemon-git-clone-provide-git-clone-bootstrap-1-open-pr`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
