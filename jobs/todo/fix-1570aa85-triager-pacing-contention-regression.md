---
role: fixer
priority: urgent
posted_by: liaison
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Fix: 1570aa85a4 broke triager-pacing contention backoff; the deploy gate rejects main2 fleet-wide

Repo: the garden itself (`kriscendobot/garden`, `main2`, push direct, no PR).

## Observed (2026-09-27 03:15Z, follower endolin-garden2-5bcdff64)
`deploy-garden.sh`'s candidate test gate rejected `1570aa85a47b` (the current `origin/main2` tip,
"fix(ci-watcher): latch soft verify lock contention"). It failed on both the attempt and the retry,
in `scripts/jobs/test/triager-pacing-test.sh`, 12 passed and 2 failed:
- `FAIL: contention backoff did not suppress the repeated warnings (tick1 warns=0, projector-calls=1, skip-warns=0, skip-msgs=0, skip-lock=0)`
- `FAIL: contention backoff did not recover after expiry (projector-calls=1)`
The full log is in `.garden-state/deploy/candidate-gate-diagnostics/1570aa85…/attempt2-01-scripts_jobs_test_triager-pacing-test.sh.log`
on endolin-garden2. The previous tip, `ab66fece68`, passes. The consequence: every host's gate rejects the
new tip, the rolling-deploy canary "fails" and the canary host gets drained, so fleet deploys are frozen
until this is fixed.

## Ask
1. Find how 1570aa85's ci-watcher soft-verify-lock latch changed the shared soft clone-lock or
   contention-latch behavior that the triager's pacing refresh relies on (`triager_pace_contention_active`,
   `triager_pace_arm_contention`, `GARDEN_CLONE_LOCK_SOFT` / `clone_lock` in `common.sh`). Restore the
   triager's contention backoff semantics without reverting the ci-watcher fix. If both need the latch,
   give them separate keys, or scope the latch per caller.
2. Run `triager-pacing-test.sh` (it must be 14/14), the ci-watcher suite, and the fetch/clone and common
   suites. Push to `main2`. Also run the same candidate gate `deploy-garden.sh` runs, if you can invoke it,
   so the next roll passes.
3. Complete via the normal completion path.
