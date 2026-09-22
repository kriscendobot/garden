Pushed successfully to `main2`. The work is complete.

## Completion report

**Job:** `improve-issue-inbox-cursor-timeout-alignment` — give `scripts/jobs/issue-inbox-watcher.sh` a cursor-specific timeout so `cursor-get.sh`'s bounded cursor-IO-lock wait can complete and return its safe temporary-unavailable result, instead of being killed at the blanket 90s stage limit with rc=124.

**Root cause:** The watcher wrapped `cursor-get.sh` (and the symmetric `cursor-set.sh` advance) in the blanket `STAGE_TIMEOUT` of 90s (`GARDEN_ISSUE_STAGE_TIMEOUT_SECS`). But both helpers hold the host-shared cursor-IO lock with their own internal bounded wait of `GARDEN_CURSOR_LOCK_WAIT` (default 300s) before giving up and returning `GARDEN_OFFLINE_RC=75` — a quiet skip. Because 90s < 300s, a wedged peer holding the lock got the helper SIGTERM/SIGKILLed at 90s → rc=124, which the read side logs as a noisy `cursor read failed … (rc=124)` WARN every tick; the helper never reached its clean rc=75 skip.

**What changed** (`scripts/jobs/issue-inbox-watcher.sh`):
- Added `GARDEN_ISSUE_CURSOR_TIMEOUT_SECS` (default `GARDEN_CURSOR_LOCK_WAIT + 60`, i.e. 360s) and a `CURSOR_STAGE_TIMEOUT` argv prefix mirroring `STAGE_TIMEOUT`. Kept under the 480s tick budget so even a maxed-out cursor wait exits cleanly before the 900s systemd SIGKILL.
- Wrapped both the `cursor-get.sh` read and the `cursor-set.sh` advance in `CURSOR_STAGE_TIMEOUT` (they share the same lock and the same misalignment), with explanatory comments.

**Regression test** (`scripts/jobs/test/issue-inbox-tick-bounds-test.sh`, new case D): the test itself holds the cursor-IO lock (the same file `cursor_io_lock` opens), sets a short `GARDEN_CURSOR_LOCK_WAIT=3`, a blanket bound below it (`STAGE_TIMEOUT_SECS=1`) and a cursor bound above it (`CURSOR_TIMEOUT_SECS=10`), and asserts the quiet rc=75 skip path (helper logs the busy lock; no `rc=124` WARN; cursor not advanced; nothing dispatched). Confirmed the case **fails against the pre-fix call site** (rc=124 guillotine, 2 failures) and **passes with the fix**.

**Verification:** `issue-inbox-tick-bounds-test` (18 passed), `issue-inbox-watcher-test` (43), `issue-inbox-journal-linkage-test` (17), `cursor-set-concurrency-test` (8), `cursor-outage-cooldown-test` (57) — all green. `bash -n` clean.

Committed `1d7a9fc94a` and pushed to `origin/main2`.

**Follow-ups:** none. The default (`+60s` grace) covers the lock wait; the post-acquire journal work is separately bounded by the fetch/outage-latch machinery, so no additional headroom is needed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-issue-inbox-cursor-timeout-alignment.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 92 tokens (3743887 cached reads)
- Output: 29074 tokens
- Cost: $3.9217364999999997
- Wall-clock: 497s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
