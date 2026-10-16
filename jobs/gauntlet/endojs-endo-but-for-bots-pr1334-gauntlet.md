---
panel_head: 911c7171c0bf350088dbd8988bbd63a848c100c1
pr: https://github.com/endojs/endo-but-for-bots/pull/1334
repo: endojs/endo-but-for-bots
pr_number: 1334
build_job: fu-endo-but-for-bots-ocapn-noise-session-reconnect-build-3
kind: feature
stage: undraft
iteration: 2
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1334-gauntlet-undraft
state: running
created_by: producer
created_at: 2026-10-16T19:59:18Z
---

# gauntlet endojs-endo-but-for-bots-pr1334-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1334 (feature).
Posted by the completion edge of build `fu-endo-but-for-bots-ocapn-noise-session-reconnect-build-3`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
