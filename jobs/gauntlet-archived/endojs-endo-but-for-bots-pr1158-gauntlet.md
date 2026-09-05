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
pr: https://github.com/endojs/endo-but-for-bots/pull/1158
repo: endojs/endo-but-for-bots
pr_number: 1158
build_job: design-exo-db
kind: feature
stage: fix
iteration: 2
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: endojs-endo-but-for-bots-pr1158-gauntlet-fix-2
state: running
created_by: producer
created_at: 2026-09-05T04:20:56Z
---

# gauntlet endojs-endo-but-for-bots-pr1158-gauntlet

Staged gauntlet run over https://github.com/endojs/endo-but-for-bots/pull/1158 (feature).
Posted by the completion edge of build `design-exo-db`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
