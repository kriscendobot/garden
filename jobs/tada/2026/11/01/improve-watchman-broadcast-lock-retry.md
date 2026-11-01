## Completion report: improve-watchman-broadcast-lock-retry

A busy producer journal lock no longer fails `garden-watchman.service`. The new test passes 15/15 and the existing `wedge-resolve-test.sh` still passes 45/45. The change is pushed to `main2` as `e52dada2e7e`; it takes effect on each host at its next deploy.

**Changes to `scripts/jobs/watchman.sh`:**
- **Retry:** the reread broadcast is now tried up to `GARDEN_WATCHMAN_BROADCAST_ATTEMPTS` times (default 3), with `backoff` between attempts, when the failure is lock contention.
- **What counts as lock contention:**
  - `send-msg.sh` exits with 75 (`GARDEN_OFFLINE_RC`).
  - The output matches `clone_lock_is_busy_contention`. This case is needed because the failure in the job spec ("cannot acquire clone lock … after 3 waits of 60s") does not actually exit 75: it exits 1 through `die`. Retrying only on 75 would have missed the incident.
- **If the lock is still busy after the last attempt:** it logs a WARN and exits 0. `SEEN` is not advanced, so the next tick tries the same advance again.
- **Other send failures** still fail the unit straight away, with no retry and with the exit code in the message.
- **Moved `SEEN` update:** it is now written as soon as a broadcast lands, before the evolution handler (`claude -p`). Before, it was written after the handler, so a handler that died or was killed caused a duplicate notice on the next tick. The handler is best-effort, so it is not retried.
- **New override:** `GARDEN_WATCHMAN_SEND_MSG`, so tests can stub the sender.

**New test `scripts/jobs/test/watchman-broadcast-test.sh`** (hermetic, uses a stub sender). It covers four cases:
- The lock stays busy: exit 0, three tries, WARN logged, `SEEN` unchanged, handler not run.
- One lock failure, then success: `SEEN` advances and the handler runs.
- The next tick with no change: nothing is broadcast.
- A failure that is not about the lock: the unit fails, there is no retry, and `SEEN` is unchanged.

**Follow-ups:** none required.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-watchman-broadcast-lock-retry.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1198822 cached reads)
- Output: 9068 tokens
- Cost: $0.9951964000000001
- Wall-clock: 100s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
