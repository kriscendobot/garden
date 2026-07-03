Inbox empty. Work complete.

## Completion report

**Problem.** In `scripts/jobs/gardener.sh`, a handler killed at its own wall-clock budget (`deadline_overrun=1`, rc=124 at the wall) could emit **two contradictory** journal progress entries: the generic *"transient handler outage … no escalation"* note **and** the accurate *"hit its OWN wall-clock budget … stamping for early poison"* note. The generic note fires whenever the requeue cycle has reached the poison-threshold edge (`cycle >= poison_threshold - 1`), so a near-poison deadline overrun double-journaled — the first entry claiming "no escalation" while the code goes on to stamp an early-poison hint.

**Fix (gardener.sh).** Gated the generic transient `printf` behind `[ "${deadline_overrun:-0}" -ne 1 ]`, combined with the existing cycle/constancy guard. Now a deadline overrun emits **only** the deadline-overrun entry; every other transient path (external signal-kill, plain timeout below the wall, empty-capture blip, transient-claude signature) emits **only** the generic entry, unchanged. The unconditional local `log` line is untouched.

**Tests (`timeout-classifier-test.sh`).**
- Added **SUBTEST 6**: seeds a job at cycle 4 (`<!-- garden-reaped: 4 -->`) with `poison_threshold=5` so the generic note's cycle guard *is* satisfied, drives it to the rc=124-at-the-wall deadline-overrun path, and asserts the generic note is suppressed and exactly one deadline-overrun note is produced. Verified it fails (generic note emitted) without the gardener.sh gate and passes with it.
- Added assertion **(i)** to SUBTEST 2 asserting exactly one transient-classification note (deadline-overrun only) on the default cycle-0 path.
- Fixed a **pre-existing failure**: SUBTEST 2's assertion (d) wrongly expected the generic "transient handler outage" note on the deadline-overrun path (that note is never emitted there — the test was already red on main2: 31/1). It now asserts the deadline-overrun note stands in for the skipped loud-error path.
- Made the four grep-count assignments pipefail-safe (`{ grep … || true; } | wc -l`).

**Verification.** `timeout-classifier-test.sh` 36/0 (was 31/1 on main2); `handler-budget-test.sh` 7/0; shellcheck clean. Committed and pushed to `main2` (`060e105b5..d71677bd2`).

**Follow-ups.** None. (Note: the CLAUDE.md dispatch mentions line numbers ~498/~523; the actual gated block is at line ~606 and the deadline-overrun note at ~613–635 — the guard is placed correctly regardless.)
