---
pr: https://github.com/endojs/endo-but-for-bots/pull/1542
repo: endojs/endo-but-for-bots
pr_number: 1542
build_job: build-ubuntu-twenty-six-sandbox-test-compatibility-open-pr
kind: feature
stage: viability
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1542-gauntlet-viability
state: running
created_by: producer
arc: minion-town-git-remote
created_at: 2026-10-22T22:07:41Z
---

# gauntlet endojs-endo-but-for-bots-pr1542-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1542 (feature).
Posted by the completion edge of build `build-ubuntu-twenty-six-sandbox-test-compatibility-open-pr`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
