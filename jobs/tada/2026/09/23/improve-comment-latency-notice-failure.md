**Completion report: improve-comment-latency-notice-failure**

A failed watchdog notice no longer stops `scripts/jobs/comment-latency-watch.sh`. The fix and a regression test are pushed to `main2` as `2de53073cf4`.

**What was wrong:** the script runs with `set -euo pipefail`. When `watchdog-notice.sh` failed (for example, during a journal or push outage), the tick stopped before it wrote the liveness heartbeat, so systemd kept restarting the service.

**What changed:**
- **Failed alert:** when an alert fails to send, the script logs a `WARN`, counts the failure and carries on. It still records the alert marker. The next tick sends the alert again while the condition lasts. If the condition clears first, the "recovered" notice is harmless, because it only closes a notice that was actually open (`RECOVERY_IF_OPEN_ONLY`).
- **Failed "recovered" notice:** the script logs a `WARN` and now keeps the alert marker, so the next tick tries the recovery again. Before, the marker was dropped.
- **End of tick:** the heartbeat is always written. If any notice failed, a summary `WARN` follows it, and the tick exits 0.
- **Regression test:** `scripts/jobs/test/comment-latency-watch-test.sh` now has a case with a notice handler that always fails. It checks that:
  - the tick exits 0 and writes the heartbeat;
  - the alert is attempted and its marker is kept;
  - a failed recovery keeps the marker;
  - once sending works again, the next tick sends the recovery and removes the marker.

**Checks:**
- The full test passes.
- With the old script, the new case fails ("notice failure aborted the tick"), so it does catch the original bug.
- `bash -n` is clean. `shellcheck` reports only the existing SC1091 info about sourced files.

**Follow-ups:** none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-comment-latency-notice-failure.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (446781 cached reads)
- Output: 6042 tokens
- Cost: $0.6058202000000001
- Wall-clock: 64s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
