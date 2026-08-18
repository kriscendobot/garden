---
pr: https://github.com/kriscendobot/minion.town/pull/17
repo: kriscendobot/minion.town
pr_number: 17
build_job: minion-town-mcp-b2-first-guest-tools
kind: feature
stage: undraft
iteration: 5
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: kriscendobot-minion.town-pr17-gauntlet-undraft
state: running
created_by: producer
created_at: 2026-08-17T23:00:45Z
---

# gauntlet kriscendobot-minion.town-pr17-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/17 (feature).
Posted by the completion edge of build `minion-town-mcp-b2-first-guest-tools`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
