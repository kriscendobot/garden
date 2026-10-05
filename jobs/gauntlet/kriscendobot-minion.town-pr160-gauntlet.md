---
panel_head: ae967c4b2426c69344c1376d1539c6fec37f300b
pr: https://github.com/kriscendobot/minion.town/pull/160
repo: kriscendobot/minion.town
pr_number: 160
build_job: build-minion-town-claude-guest-scoped-mcp-gauntlet-fix-2
kind: feature
stage: panel
iteration: 3
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: kriscendobot-minion.town-pr160-gauntlet-panel-3
state: running
created_by: producer
created_at: 2026-10-05T18:08:52Z
---

# gauntlet kriscendobot-minion.town-pr160-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/160 (feature).
Posted by the completion edge of build `build-minion-town-claude-guest-scoped-mcp-gauntlet-fix-2`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
