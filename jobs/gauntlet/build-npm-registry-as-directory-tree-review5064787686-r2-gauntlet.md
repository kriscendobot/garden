---
pr: https://github.com/endojs/endo-but-for-bots/pull/1117
repo: endojs/endo-but-for-bots
pr_number: 1117
build_job: build-npm-registry-as-directory-tree-review5064787686-r2
kind: feature
stage: clean
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: build-npm-registry-as-directory-tree-review5064787686-r2-gauntlet-clean
state: running
created_by: producer
created_at: 2026-09-02T01:11:08Z
---

# gauntlet build-npm-registry-as-directory-tree-review5064787686-r2-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1117 (feature).
Posted by the completion edge of build `build-npm-registry-as-directory-tree-review5064787686-r2`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
