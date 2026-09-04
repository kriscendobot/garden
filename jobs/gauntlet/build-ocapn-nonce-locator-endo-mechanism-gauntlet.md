---
pr: https://github.com/endojs/endo-but-for-bots/pull/1124
repo: endojs/endo-but-for-bots
pr_number: 1124
build_job: build-ocapn-nonce-locator-endo-mechanism
kind: feature
stage: panel
iteration: 3
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: build-ocapn-nonce-locator-endo-mechanism-gauntlet-panel-3
state: running
created_by: producer
created_at: 2026-09-03T15:44:15Z
---

# gauntlet build-ocapn-nonce-locator-endo-mechanism-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1124 (feature).
Posted by the completion edge of build `build-ocapn-nonce-locator-endo-mechanism`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
