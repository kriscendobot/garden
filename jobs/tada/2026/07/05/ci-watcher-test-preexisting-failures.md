Pushed to main2. Done.

## Completion report

**Diagnosis:** The 6/29 failures were an **environmental time-bomb in the test**, not a main2 regression in `ci-watcher.sh`.

- The watcher's default `GARDEN_CI_ACTIVITY_WINDOW` is `3 days` (`ci-watcher.sh:84`, Gate 3): a PR untouched beyond the window is skipped *before* its rollup read.
- The test's `prline` helper defaulted `updated_at` to a hardcoded `2026-07-01T00:00:00Z`. Cases A, B, and H seed their fixtures through that default and don't override the window. When the suite was written (~2026-07-01) those PRs were fresh; run on 2026-07-05 they are 4 days stale (cutoff `2026-07-02`), so all their red bot PRs got skipped → the six "shepherd job missing / expected N jobs, got 0" failures.
- Cases I/J/K already compute their timestamps against the real clock (`FRESH_TS`/`STALE_TS`) and always passed — confirming the scripts themselves are correct.

**Fix:** Made `prline`'s default `updated_at` clock-relative — it now defaults to the same `FRESH_TS` (`date -u -d '-1 hour'`) the window cases already use, and moved the `FRESH_TS`/`STALE_TS` computation above `prline` (removing the later duplicate). The fixtures now stay inside the activity window on any run date.

**Verification:** `ci-watcher-test.sh` now reports `29 passed, 0 failed`.

**Changed:** `scripts/jobs/test/ci-watcher-test.sh` (committed `b527dba9b`, pushed to `origin/main2`).

**Follow-ups:** None. No production script changed. Worth noting the general pattern for future test authoring — any fixture timestamp compared against a relative window must be clock-relative, never a fixed literal.
