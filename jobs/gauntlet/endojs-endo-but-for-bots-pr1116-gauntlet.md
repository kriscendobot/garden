---
pr: https://github.com/endojs/endo-but-for-bots/pull/1116
repo: endojs/endo-but-for-bots
pr_number: 1116
build_job: endo-guest-invite-accept-design
kind: feature
stage: panel
iteration: 3
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1116-gauntlet-panel-3
state: running
created_by: producer
created_at: 2026-09-02T00:24:47Z
---

# gauntlet endojs-endo-but-for-bots-pr1116-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1116 (feature).
Posted by the completion edge of build `endo-guest-invite-accept-design`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
