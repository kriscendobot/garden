Done. Completion report:

---

## Job complete: `harden-run-test-scheduler-cadence-determinism`

**Problem.** `run-test.sh` SUBTEST 8 flaked under fleet load (`FAIL: re-run dispatched`). Its "immediate re-run dispatches nothing" assertion relied on the real wall-clock gap between two back-to-back `scheduler.sh` invocations staying under the 1s test cadence — on a busy host (~100 gardeners) that gap exceeds 1s, so the 1s schedule legitimately re-fired and the assertion failed. A timing fragility, not a journal-isolation issue.

**Fix (chosen direction: deterministic now-override).** Added a `GARDEN_SCHEDULER_NOW` epoch-second clock override to `scripts/jobs/scheduler.sh`, mirroring the existing `GARDEN_FOREMAN_NOW` / `GARDEN_USAGE_NOW` pattern:
- New `scheduler_now()` helper; `now="$(scheduler_now)"` replaces the bare `date -u +%s`.
- When the override is set it drives **all three** time-derived values for the tick: the cadence comparison, the `last_dispatched` stamp (`date -u -d "@$now" +%FT%TZ`), and the dispatched job's timestamped basename (`date -u -d "@$now" +%Y%m%d-%H%M%S`). Deriving the basename from the same clock keeps job filenames unique across ticks without a real-time sleep, which the `t3 > t2` assertion needs.
- Production behavior is unchanged — with the var unset it falls back to real `date`.

**Test.** SUBTEST 8 now drives three `scheduler.sh` runs with a fixed `T0=2000000000` (large enough that the weekly schedule, `last_dispatched=0`, is due on the first tick), `T0` again (proves immediate re-run dispatches nothing), and `T0+2` (proves only the 1s tick re-fires after the cadence). The `sleep 1.2` is gone. The assertions' original intent is preserved.

**Verification.** Built in an isolated worktree off `origin/main2`. `bash -n` clean on both files. Ran the full `run-test.sh`: all three SUBTEST 8 assertions PASS (`first tick dispatched both`, `immediate re-run dispatches nothing`, `after 1s only the 1s-cadence tick re-dispatches`), along with every preceding subtest. The fix is now deterministic by construction — no wall-clock dependency remains in the cadence assertions.

**Landed.** Committed with explicit pathspecs under the `endolinbot` identity and pushed `HEAD:main2` via a git-rebase CAS loop (succeeded first attempt; `origin/main2` == `2e3372fbe`). Worktree removed.

**Follow-ups.** None. The change is self-contained; no other caller of `scheduler.sh` is affected, and no other subtest references the scheduler clock.
