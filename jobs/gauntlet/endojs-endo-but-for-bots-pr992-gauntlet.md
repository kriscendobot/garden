---
pr: https://github.com/endojs/endo-but-for-bots/pull/992
repo: endojs/endo-but-for-bots
pr_number: 992
build_job: endojs-endo-but-for-bots-http-adapter-pipeline-design
kind: feature
stage: fix
iteration: 2
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: endojs-endo-but-for-bots-pr992-gauntlet-fix-2
state: running
created_by: producer
created_at: 2026-08-15T06:34:19Z
---

# gauntlet endojs-endo-but-for-bots-pr992-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/992 (feature).
Posted by the completion edge of build `endojs-endo-but-for-bots-http-adapter-pipeline-design`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
