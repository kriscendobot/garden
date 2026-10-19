---
panel_head: e18af8019c6e86eb7ac7ebdac20e6d28df1ac0e2
pr: https://github.com/endojs/endo-but-for-bots/pull/1497
repo: endojs/endo-but-for-bots
pr_number: 1497
build_job: daemon-agent-tools-design
kind: feature
stage: undraft
iteration: 3
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1497-gauntlet-undraft
state: running
created_by: producer
arc: unallocated
created_at: 2026-10-19T04:24:03Z
---

# gauntlet endojs-endo-but-for-bots-pr1497-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1497 (feature).
Posted by the completion edge of build `daemon-agent-tools-design`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
