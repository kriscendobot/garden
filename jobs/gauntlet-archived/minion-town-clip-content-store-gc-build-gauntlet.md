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
pr: https://github.com/kriscendobot/minion.town/pull/93
repo: kriscendobot/minion.town
pr_number: 93
build_job: minion-town-clip-content-store-gc-build
kind: feature
stage: panel
iteration: 5
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: minion-town-clip-content-store-gc-build-gauntlet-panel-5
state: running
created_by: producer
created_at: 2026-09-04T23:21:42Z
---

# gauntlet minion-town-clip-content-store-gc-build-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/93 (feature).
Posted by the completion edge of build `minion-town-clip-content-store-gc-build`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
