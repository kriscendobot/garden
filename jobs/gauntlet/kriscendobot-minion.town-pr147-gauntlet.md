---
pr: https://github.com/kriscendobot/minion.town/pull/147
repo: kriscendobot/minion.town
pr_number: 147
build_job: design-minion-town-mcp-resources-getting-started
kind: feature
stage: fix
iteration: 5
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: kriscendobot-minion.town-pr147-gauntlet-fix-5
state: running
created_by: producer
created_at: 2026-10-02T01:24:34Z
---

# gauntlet kriscendobot-minion.town-pr147-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/147 (feature).
Posted by the completion edge of build `design-minion-town-mcp-resources-getting-started`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
