---
stage_retries: 1
pr: https://github.com/kriscendobot/agoric-sdk/pull/18
repo: kriscendobot/agoric-sdk
pr_number: 18
build_job: 
kind: feature
stage: fix
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: kriscendobot-agoric-sdk-pr18-gauntlet-fix-1
state: running
created_by: design-pr-gauntlet-coverage-audit
created_at: 2026-08-30T07:39:31Z
---

# gauntlet kriscendobot-agoric-sdk-pr18-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/agoric-sdk/pull/18 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
