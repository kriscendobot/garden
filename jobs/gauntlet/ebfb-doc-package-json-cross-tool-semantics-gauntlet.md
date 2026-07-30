---
pr: https://github.com/endojs/endo-but-for-bots/pull/893
repo: endojs/endo-but-for-bots
pr_number: 893
build_job: ebfb-doc-package-json-cross-tool-semantics
kind: feature
stage: panel
iteration: 1
max_iterations: 6
current_child: ebfb-doc-package-json-cross-tool-semantics-gauntlet-panel-1
state: running
created_by: producer
created_at: 2026-07-30T21:25:20Z
---

# gauntlet ebfb-doc-package-json-cross-tool-semantics-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/893 (feature).
Posted by the completion edge of build `ebfb-doc-package-json-cross-tool-semantics`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
