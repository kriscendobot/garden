---
pr: https://github.com/endojs/endo-but-for-bots/pull/1404
repo: endojs/endo-but-for-bots
pr_number: 1404
build_job: ebfb-guest-no-identifiers-locators
kind: feature
stage: panel
iteration: 5
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: ebfb-guest-no-identifiers-locators-gauntlet-panel-5
state: running
created_by: producer
created_at: 2026-10-01T06:01:51Z
---

# gauntlet ebfb-guest-no-identifiers-locators-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1404 (feature).
Posted by the completion edge of build `ebfb-guest-no-identifiers-locators`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
