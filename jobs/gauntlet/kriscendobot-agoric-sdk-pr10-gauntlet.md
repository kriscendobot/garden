---
pr: https://github.com/kriscendobot/agoric-sdk/pull/10
repo: kriscendobot/agoric-sdk
pr_number: 10
build_job: fix-gauntlet-audit-restages-finished-prs-20261006
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
created_at: 2026-10-06T09:43:56Z
---

# gauntlet kriscendobot-agoric-sdk-pr10-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/agoric-sdk/pull/10 (feature).
Posted by the completion edge of build `fix-gauntlet-audit-restages-finished-prs-20261006`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
