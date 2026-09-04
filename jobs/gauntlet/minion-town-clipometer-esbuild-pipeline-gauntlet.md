---
stage_retries: 0
pr: https://github.com/kriscendobot/minion.town/pull/84
repo: kriscendobot/minion.town
pr_number: 84
build_job: minion-town-clipometer-esbuild-pipeline
kind: feature
stage: panel
iteration: 3
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: minion-town-clipometer-esbuild-pipeline-gauntlet-panel-3
state: running
created_by: producer
created_at: 2026-09-03T21:43:02Z
---

# gauntlet minion-town-clipometer-esbuild-pipeline-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/84 (feature).
Posted by the completion edge of build `minion-town-clipometer-esbuild-pipeline`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
