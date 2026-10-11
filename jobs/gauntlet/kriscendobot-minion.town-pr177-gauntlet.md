---
pr: https://github.com/kriscendobot/minion.town/pull/177
repo: kriscendobot/minion.town
pr_number: 177
build_job: minion-town-git-remote-served-clip-design
kind: feature
stage: fix
iteration: 1
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: kriscendobot-minion.town-pr177-gauntlet-fix-1
state: running
created_by: producer
arc: minion-town-git-remote
created_at: 2026-10-11T01:35:40Z
---

# gauntlet kriscendobot-minion.town-pr177-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/177 (feature).
Posted by the completion edge of build `minion-town-git-remote-served-clip-design`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: viability -> clean -> panel-1 -> (fix-k -> panel-(k+1))* -> undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
