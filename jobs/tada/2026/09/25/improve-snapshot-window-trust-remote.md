`meter_remote_snapshot_total` no longer rejects a live snapshot just because its window differs from the reader's. When pool, cap, spend and timestamps all match, it now uses the snapshot's own `window_start_epoch` and returns the spend with rc 0. The fix is pushed to `main2` as `c4b4d2528ce`. The job's target test and six other budget/snapshot test scripts all pass.

**What changed in `scripts/jobs/usage-meter.sh`:**
- **The check:** the window test in both read paths (the per-pool directory loop and the legacy host-keyed path) now only asks that `window_start_epoch` be a well-formed number, not that it equal the reader's `cutoff`.
- **A note on window drift:** a new helper, `_meter_snapshot_window_note`, writes one line to stderr when the snapshot is accepted but its window differs: `snapshot window trusted file=<pool>/<host> window=<file>/<expected>`. The call still succeeds.
- **What still returns rc 9:** a pool or cap mismatch, or a missing or malformed window, spend or sample time. If the window also differs in that case, the rc 9 message still names it (for example `diverged=cap,window`).
- The header comment now documents why the publishing host's window is trusted.

**Tests (`scripts/jobs/test/live-budget-admission-test.sh`):** the old test expected a window-only difference to fail with rc 9. It now checks that such a snapshot returns rc 0 with spend 42 and the stderr note. New tests cover cap plus window drift (still rc 9, naming both fields) and a malformed window (rc 9). That script gives 58 passed, 0 failed.

**Follow-ups:**
- Because the reader now trusts the publisher's window, a genuinely stale window from a publisher would be accepted too. The new stderr note is the only trace, and `budget-level.sh` only reports stderr when rc is 9, so these notes aren't shown anywhere yet.
- The reader's out-of-date journal reset fact for `claude-oros` is still the underlying cause. Refreshing it is separate work.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-snapshot-window-trust-remote.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (475370 cached reads)
- Output: 4807 tokens
- Cost: $0.6114780000000001
- Wall-clock: 83s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
