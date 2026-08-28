---
pr: https://github.com/endojs/endo-but-for-bots/pull/1074
repo: endojs/endo-but-for-bots
pr_number: 1074
build_job: 
kind: feature
stage: clean
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: endojs-endo-but-for-bots-pr1074-gauntlet-resume-20260828-0935-clean
state: running
created_by: mentor
created_at: 2026-08-28T09:37:25Z
---

# gauntlet endojs-endo-but-for-bots-pr1074-gauntlet-resume-20260828-0935

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1074 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
