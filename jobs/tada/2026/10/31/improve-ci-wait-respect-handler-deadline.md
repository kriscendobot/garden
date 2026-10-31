I fixed `ci-wait-merge.sh` so its CI wait now ends before the job's handler deadline and returns rc 4 when there isn't enough time left. It is pushed to main2 as `a8afe6dde59`. The shell test suite passes; the two Python test suites for this script already fail on main2 without my change (details below).

**How it works now** (`scripts/jobs/gardening/ci-wait-merge.sh`)
- **Clamped deadline:** the wait now ends at whichever comes first: the configured CI deadline (`GARDEN_CI_DEADLINE_SECS`) or `GARDEN_HANDLER_DEADLINE_EPOCH` minus a reserve for exiting and reporting. The reserve is a new setting, `GARDEN_CI_HANDLER_RESERVE_SECS`, defaulting to 300s to match the pre-push gates' margin. A missing or non-numeric handler deadline means no clamp. When the clamp shortens the wait, it logs a line saying so.
- **Too little time left:** if the clamped end is already reached at startup, the script exits 4 (`ci-wait-timeout … insufficient handler time`). This happens before it touches the PR's base or rebases, so the gauntlet driver can repost the stage cleanly.
- **All timeout checks use the clamped end:** the empty-rollup, pending, and repeated-read-failure timeouts all exit 4 at that time.
- **When the base moves mid-wait:** the wait restarts as before, but the end is recomputed and still clamped. If no time is left at that point, it exits 4.
- **Polling:** waits between checks are cut short so they never sleep past the end.
- The header comment now covers the new rc 4 case and the new setting.

**Tests** (`scripts/jobs/test/ci-wait-merge-test.sh`)
- The suite now unsets `GARDEN_HANDLER_DEADLINE_EPOCH` first, so a gardener's own deadline can't leak into the test cases.
- I added three cases:
  - **T61:** a handler deadline inside the reserve exits 4 with no rebase and no merge.
  - **T62:** a long CI deadline gets clipped and exits 4 promptly at the clipped end.
  - **T63:** with plenty of handler time, a normal green merge goes through unchanged.
- Result: `PASS=160 FAIL=0`.

**Follow-up:** `ci-wait-merge-ratchet-test.py` (10 failures) and `ci-wait-merge-screening-test.py` (11 failures) fail the same way on unmodified main2. Their stubs don't seem to answer the Actions runs inventory read, so the script ends with "gh read kept failing" and exits 4. That predates this change and I didn't post a job for it; one is needed to update those stubs.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-ci-wait-respect-handler-deadline.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (1054422 cached reads)
- Output: 8968 tokens
- Cost: $1.0539243999999999
- Wall-clock: 228s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
