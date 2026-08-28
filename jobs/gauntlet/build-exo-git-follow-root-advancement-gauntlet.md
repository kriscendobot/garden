---
pr: https://github.com/endojs/endo-but-for-bots/pull/1080
repo: endojs/endo-but-for-bots
pr_number: 1080
build_job: build-exo-git-follow-root-advancement
kind: feature
stage: panel
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: build-exo-git-follow-root-advancement-gauntlet-panel-1
state: running
created_by: producer
created_at: 2026-08-28T19:28:43Z
---

# gauntlet build-exo-git-follow-root-advancement-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1080 (feature).
Posted by the completion edge of build `build-exo-git-follow-root-advancement`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
