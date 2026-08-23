---
pr: https://github.com/endojs/endo-but-for-bots/pull/796
repo: endojs/endo-but-for-bots
pr_number: 796
build_job: 
kind: feature
stage: fix
iteration: 6
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: endojs-endo-but-for-bots-pr796-gauntlet-resume-20260822-fix-6
state: running
created_by: fixer
created_at: 2026-08-22T14:43:29Z
---

# gauntlet endojs-endo-but-for-bots-pr796-gauntlet-resume-20260822

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/796 (feature).

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
