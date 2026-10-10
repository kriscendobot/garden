---
panel_head: 1b1ead43c8e117314d38e9640ca0c0d20b55fc4e
pr: https://github.com/endojs/endo-but-for-bots/pull/1427
repo: endojs/endo-but-for-bots
pr_number: 1427
build_job: 
kind: feature
stage: panel
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1427-gauntlet-panel-1
state: running
created_by: design-pr-gauntlet-coverage-audit
created_at: 2026-10-10T03:47:53Z
---

# gauntlet endojs-endo-but-for-bots-pr1427-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1427 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
