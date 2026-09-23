---
archived: true
archived_at: 2026-09-05T11:59:00Z
archived_by: liaison
archived_reason: maintainer: archive all scheduled gauntlets during the fleet drain; resume manually if needed
---

<!-- ARCHIVED gauntlet record. gauntlet.sh only reads jobs/gauntlet/, so this
     record is inert here -- any stage job already in flight when this was
     archived will finish normally, but the driver will NOT post the next
     stage. To resume: git mv this file back to jobs/gauntlet/<name>.md
     (restoring the original basename) and the driver picks it up on its next
     tick from the state below, unchanged. -->

---
stage_retries: 0
pr: https://github.com/kriscendobot/minion.town/pull/83
repo: kriscendobot/minion.town
pr_number: 83
build_job: minion-town-formula-graph-content-gc
kind: feature
stage: fix
iteration: 4
max_iterations: 6
resumes: 0
max_resumes: 6
current_child: minion-town-formula-graph-content-gc-gauntlet-fix-4
state: running
created_by: producer
created_at: 2026-09-03T21:44:50Z
---

# gauntlet minion-town-formula-graph-content-gc-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/83 (feature).
Posted by the completion edge of build `minion-town-formula-graph-content-gc`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
