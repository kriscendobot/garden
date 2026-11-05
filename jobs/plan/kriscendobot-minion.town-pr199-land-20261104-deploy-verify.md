---
gate: orchestrated
orchestrated_by: kriscendobot-minion.town-pr199-land-20261104-split
priority: normal
posted_by: producer
posted_at: 2026-11-05T01:28:43Z
---

---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
handler-timeout: 3600
---
**Confirm the production deploy of minion.town `main` is green and includes #199, and that the phase-1 successor is promoted.** Read the merge SHA from the tada report of `kriscendobot-minion.town-pr199-land-20261104-merge`.

1. Poll in the foreground (shell calls under 400s) for the `deploy.yml` Actions run on `main` in kriscendobot/minion.town (`gh api repos/kriscendobot/minion.town/actions/workflows/deploy.yml/runs?branch=main`). Require a run that concluded `success` whose head SHA has the merge commit as an ancestor (`gh api repos/kriscendobot/minion.town/compare/<merge>...<run-sha>`, status ahead or identical). If the deploy fails, report the run URL and emit `<<<GARDEN-ORCHESTRATION-FAILED>>>`: the next child flips production admission and must not run on a broken deploy.
2. Ensure `build-minion-town-guest-coupons-phase1-rest` has left `jobs/plan/` on fresh `origin/journal2`. It is `blocked_on` the PR, so `unblock.sh` should promote it on merge; wait a few ticks, and if it is still parked use `scripts/jobs/promote-plan.sh`.

Change nothing else: the flip and the coupons are the next child's work, not this one's.
