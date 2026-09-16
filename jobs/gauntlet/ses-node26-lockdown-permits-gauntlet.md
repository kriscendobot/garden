---
pr: https://github.com/endojs/endo-but-for-bots/pull/1281
repo: endojs/endo-but-for-bots
pr_number: 1281
build_job: ses-node26-lockdown-permits
kind: feature
stage: fix
iteration: 4
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: ses-node26-lockdown-permits-gauntlet-fix-4
state: running
created_by: producer
created_at: 2026-09-15T23:13:52Z
---

# gauntlet ses-node26-lockdown-permits-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1281 (feature).
Posted by the completion edge of build `ses-node26-lockdown-permits`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
