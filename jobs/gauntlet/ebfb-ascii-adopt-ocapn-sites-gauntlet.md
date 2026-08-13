---
pr: https://github.com/endojs/endo-but-for-bots/pull/980
repo: endojs/endo-but-for-bots
pr_number: 980
build_job: ebfb-ascii-adopt-ocapn-sites
kind: feature
stage: panel
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: ebfb-ascii-adopt-ocapn-sites-gauntlet-panel-1
state: running
created_by: producer
created_at: 2026-08-13T21:46:34Z
---

# gauntlet ebfb-ascii-adopt-ocapn-sites-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/980 (feature).
Posted by the completion edge of build `ebfb-ascii-adopt-ocapn-sites`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
