**Completion report: self-heal-fix-garden-ci-watcher-verify-clone-lock-busy-soft**

The fix is pushed to `main2` as `ad55dea66f9`. A busy lock holder on `ci-watcher.sh`'s verify clone now produces a quiet exit 75 instead of a FATAL rc=1, so it no longer triggers self-heal. The ci-watcher suite passes (88/0, re-run after rebasing onto a peer's commit), and the new test fails when the fix is removed.

**What I found:** the job's diagnosis was partly out of date. Commits from about two hours earlier had already given each repo its own verify clone (so separate `ci-watcher@<repo>` instances no longer share one lock), and `ensure_clone_or_latch_outage` already treats a busy lock quietly. But `4948cdd9a75` had moved a hard `clone_lock "$VERIFY"` into `verify_fetch()`'s main shell, before the subshell that does that handling. So when two runs overlap on the same slug (a manual tick next to the systemd one, or a shared `GARDEN_CI_VERIFY_CLONE` override), the second run still waited the full 3×60s and then died FATAL. That meant the comment's "quiet exit 75, not FATAL" was still wrong for a busy lock.

**What changed:**
- **`scripts/jobs/ci-watcher.sh`**: `verify_fetch()` now takes the lock with `GARDEN_CLONE_LOCK_SOFT=1 clone_lock "$VERIFY"`, the same approach the triager uses for its pacing clone. A busy live holder now costs one short wait and a quiet exit 75. The comments now say the board check is optional work (a missed tick just waits for the next firing) and that both a busy lock and a network timeout exit 75. That claim is now true.
- **`scripts/jobs/common.sh`**: comment only. `clone_lock`'s note that soft mode is "only ever set for the triager pacing subshell" now lists every caller that uses it.
- **`scripts/jobs/test/ci-watcher-test.sh`**: new VBUSY section. It holds the verify lock with a live holder (its own pid and a fresh stamp, so it can't be reclaimed as stale). It asserts rc=75, no FATAL, and an early give-up (1s) instead of the 30s wait.

**Tests:**
- `ci-watcher-test.sh`: 88 passed, 0 failed.
- `cursor-outage-cooldown-test.sh`: 61 passed, 0 failed.
- With the fix reverted, VBUSY fails: the full wait ladder ran for 60s.

**Follow-ups:** none required. Hosts pick this up on the next rolling deploy. Until then, a FATAL "cannot acquire clone lock …/verify*.lock" from ci-watcher is just the deploy lag, not a new bug.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-ci-watcher-verify-clone-lock-busy-soft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (734753 cached reads)
- Output: 7830 tokens
- Cost: $0.8254545999999998
- Wall-clock: 170s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
