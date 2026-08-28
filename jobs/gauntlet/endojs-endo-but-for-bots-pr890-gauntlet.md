---
pr: https://github.com/endojs/endo-but-for-bots/pull/890
repo: endojs/endo-but-for-bots
pr_number: 890
build_job: deadmail-issue-comment-5455406421
kind: feature
stage: clean
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: 
state: pending
created_by: producer
created_at: 2026-08-28T21:14:16Z
---

# gauntlet endojs-endo-but-for-bots-pr890-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/890 (feature).
Posted by the completion edge of build `deadmail-issue-comment-5455406421`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
