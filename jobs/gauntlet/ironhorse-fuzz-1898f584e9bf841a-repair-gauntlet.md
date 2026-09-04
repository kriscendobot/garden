---
stage_retries: 0
pr: https://github.com/endojs/endo-but-for-bots/pull/1088
repo: endojs/endo-but-for-bots
pr_number: 1088
build_job: ironhorse-fuzz-1898f584e9bf841a-repair
kind: feature
stage: undraft
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: ironhorse-fuzz-1898f584e9bf841a-repair-gauntlet-undraft
state: running
created_by: producer
created_at: 2026-08-31T03:07:48Z
---

# gauntlet ironhorse-fuzz-1898f584e9bf841a-repair-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1088 (feature).
Posted by the completion edge of build `ironhorse-fuzz-1898f584e9bf841a-repair`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
