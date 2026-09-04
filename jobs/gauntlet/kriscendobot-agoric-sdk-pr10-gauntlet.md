---
stage_retries: 0
pr: https://github.com/kriscendobot/agoric-sdk/pull/10
repo: kriscendobot/agoric-sdk
pr_number: 10
build_job: 
kind: feature
stage: fix
iteration: 2
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: kriscendobot-agoric-sdk-pr10-gauntlet-fix-2
state: halted
created_by: design-pr-gauntlet-coverage-audit
created_at: 2026-08-30T07:39:42Z
---

# gauntlet kriscendobot-agoric-sdk-pr10-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/agoric-sdk/pull/10 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.


## HALTED 2026-09-04

Maintainer directive (kriskowal, 2026-09-04): archive all garden engagements on agoric-sdk — a dedicated garden instance owns that repo now, to avoid duplicate/conflicting work. The in-flight `fix-2` stage (already claimed on garden2) is left to finish on its own since it cannot be safely interrupted cross-host; this record is marked halted so the driver posts no further stage (no panel-3) once it completes. This bypasses the driver's own `finish_gauntlet` bookkeeping (notify/tada-record), done by hand instead — a full internal-halt pass was not run.
