---
pr: https://github.com/kriscendobot/minion.town/pull/81
repo: kriscendobot/minion.town
pr_number: 81
build_job: build-minion-town-invitation-only-guest-onboarding
kind: feature
stage: clean
iteration: 0
max_iterations: 6
resumes: 0
max_resumes: 6
stage_retries: 0
max_stage_retries: 2
current_child: 
state: pending
created_by: producer
created_at: 2026-09-02T00:50:46Z
---

# gauntlet build-minion-town-invitation-only-guest-onboarding-gauntlet

Staged gauntlet run over https://github.com/kriscendobot/minion.town/pull/81 (feature).
Posted by the completion edge of build `build-minion-town-invitation-only-guest-onboarding`.

The deterministic gauntlet.sh driver walks this PR one claim-sized stage at
a time: clean → panel-1 → (fix-k → panel-(k+1))* → undraft. No single handler
spans the loop; each stage is its own fresh-budget claimable job.
