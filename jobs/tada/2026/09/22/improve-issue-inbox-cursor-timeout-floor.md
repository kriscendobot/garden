Pushed to main2 on the first attempt. Work is complete.

## Completion report

**Job:** `improve-issue-inbox-cursor-timeout-floor` — cursor reads in `scripts/jobs/issue-inbox-watcher.sh` repeatedly timed out with rc=124 despite the helper's intended lock-wait handling.

**Root cause:** The prior fix (`1d7a9fc94a4`) derived `GARDEN_ISSUE_CURSOR_TIMEOUT_SECS` from the cursor-IO lock wait using a bare `:=` **default**. That only helps when nobody sets the variable — a unit env, a host override, or a stale config that pins it *below* the lock wait reintroduced the exact rc=124 guillotine: `timeout` SIGKILLs the cursor helper mid-wait before its `flock -w` can expire to the clean rc=75 temporary-unavailable skip, and the read side logs a noisy "cursor read failed … rc=124" WARN every tick a peer holds the lock.

**What changed:**
- `scripts/jobs/issue-inbox-watcher.sh`: turned the derivation into an enforced **floor**. It now computes `floor = GARDEN_CURSOR_LOCK_WAIT + grace`, uses it as the default, and **raises any lower override back up to the floor** with a WARN naming both numbers. The grace is now a named knob, `GARDEN_ISSUE_CURSOR_TIMEOUT_GRACE_SECS` (default 60, matching the prior hard-coded `+60`), absorbing the helper's pre-lock `ensure_clone` and post-lock fetch. No environment value can now guillotine the helper before it returns its own verdict.
- `scripts/jobs/test/issue-inbox-tick-bounds-test.sh`: added case **E** — forces a wedged cursor-IO lock with a 1s override under a 3s lock wait (floor 5s) and asserts the raise WARN fires, the helper reaches its own rc=75 quiet skip, and no rc=124 guillotine WARN appears.

**Verification:** Full test suite passes — 23/23 (cases A–E), including the new floor-enforcement case. `bash -n` and shellcheck clean.

**Follow-ups:** None. The durable root cause of a wedged cursor lock (a slow/degraded journal) is unchanged and already handled by the existing tick-budget mechanism; this fix only ensures the cursor stage's `timeout` ceiling can never be configured below the helper's own bounded wait.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-issue-inbox-cursor-timeout-floor.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (1103269 cached reads)
- Output: 13596 tokens
- Cost: $1.7946434999999998
- Wall-clock: 216s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
