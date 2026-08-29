---
pr: https://github.com/endojs/endo-but-for-bots/pull/1085
repo: endojs/endo-but-for-bots
pr_number: 1085
build_job: endojs-endo-but-for-bots-mount-stream-glob-grep-build
kind: feature
stage: clean
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: endojs-endo-but-for-bots-mount-stream-glob-grep-build-gauntlet-clean
state: running
created_by: producer
created_at: 2026-08-29T05:29:56Z
---

# gauntlet endojs-endo-but-for-bots-mount-stream-glob-grep-build-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1085 (feature).
Posted by the completion edge of build `endojs-endo-but-for-bots-mount-stream-glob-grep-build`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
