---
pr: https://github.com/endojs/endo-but-for-bots/pull/1113
repo: endojs/endo-but-for-bots
pr_number: 1113
build_job: ironhorse-test262-fable-supervisor-20260829
kind: feature
stage: clean
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: 
state: pending
created_by: producer
created_at: 2026-09-02T04:28:27Z
---

# gauntlet ironhorse-test262-fable-supervisor-20260829-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1113 (feature).
Posted by the completion edge of build `ironhorse-test262-fable-supervisor-20260829`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
