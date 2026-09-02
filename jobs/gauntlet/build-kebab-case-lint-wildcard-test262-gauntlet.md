---
pr: https://github.com/endojs/endo-but-for-bots/pull/762
repo: endojs/endo-but-for-bots
pr_number: 762
build_job: build-kebab-case-lint-wildcard-test262
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
created_at: 2026-09-02T06:06:24Z
---

# gauntlet build-kebab-case-lint-wildcard-test262-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/762 (feature).
Posted by the completion edge of build `build-kebab-case-lint-wildcard-test262`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
