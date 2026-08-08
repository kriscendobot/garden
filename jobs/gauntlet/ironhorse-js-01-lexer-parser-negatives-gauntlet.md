---
pr: https://github.com/endojs/endo-but-for-bots/pull/970
repo: endojs/endo-but-for-bots
pr_number: 970
build_job: ironhorse-js-01-lexer-parser-negatives
kind: feature
stage: panel
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: ironhorse-js-01-lexer-parser-negatives-gauntlet-panel-1
state: running
created_by: producer
created_at: 2026-08-08T06:06:04Z
---

# gauntlet ironhorse-js-01-lexer-parser-negatives-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/970 (feature).
Posted by the completion edge of build `ironhorse-js-01-lexer-parser-negatives`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
