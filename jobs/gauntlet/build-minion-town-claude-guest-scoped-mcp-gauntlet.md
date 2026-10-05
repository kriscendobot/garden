---
pr: https://github.com/kriscendobot/minion.town/pull/160
repo: kriscendobot/minion.town
pr_number: 160
build_job: build-minion-town-claude-guest-scoped-mcp
kind: feature
stage: panel
iteration: 2
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: build-minion-town-claude-guest-scoped-mcp-gauntlet-panel-2
state: running
created_by: gardener
created_at: 2026-10-05T16:52:28Z
---

# gauntlet build-minion-town-claude-guest-scoped-mcp-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/160 (feature).
Posted by the completion edge of build `build-minion-town-claude-guest-scoped-mcp`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
