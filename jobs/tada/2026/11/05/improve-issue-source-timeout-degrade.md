**Completion report: `improve-issue-source-timeout-degrade`**

A source timeout (rc=124 or 137) in the issue-inbox watcher now skips the tick and keeps the cursor instead of failing the unit. The fix is pushed to `main2` as `ec82c284679`; the rolling deploy has not picked it up yet.

**`scripts/jobs/issue-inbox-watcher.sh`** now handles rc=124/137 before the FATAL path and exits 0 before reading any source output, so partial rows are dropped. It follows the `comment-watcher.sh` policy:

| What the source's stderr shows | Action | Heartbeat |
| --- | --- | --- |
| Admission refusal under a live latch | Stays quiet and leaves the owner's latch alone | `cooldown` |
| Primary-quota text | Opens the primary latch, with one warning | `cooldown` |
| Shared network or API failure | Opens the transient latch, with one warning | `cooldown` |
| Nothing identifiable | One local warning, no shared latch | `source-timeout` |

Admission-refusal lines are removed before classifying. Their fake "API rate limit" wording therefore can't start a new primary-quota latch once the owner's latch has expired.

**`scripts/jobs/handlers/issue-source-gh.sh`** had the same problem one level down, which the job didn't mention. A `gh` call hitting the wrapper's time limit twice ended in FATAL with rc=1. It now exits 124 and takes the same path.

**Tests:**
- **`issue-inbox-watcher-test.sh`:** 87 passed, 0 failed. New cases cover real rc=124 and 137 expiry, both latch paths, admission-refusal collateral, and the real source with `gh` timing out.
- **Without the fix:** the same suite had 10 failures. The collateral case passes either way, so it guards against regressions rather than reproducing the bug.
- **Other checks:** `issue-inbox-tick-bounds-test.sh` (23 passed) and `issue-inbox-journal-linkage-test.sh` (17 passed) are clean. shellcheck's only warning is an SC2034 on the `GARDEN_TAG` line, which this change didn't touch. I did not run the full `run-test.sh`.

**Differences from the comment watcher, both deliberate:**
- **No per-repo backoff:** this is the maintainer's command channel, and each attempt already takes up to 180s, so it retries on the normal timer.
- **Not counted in the comment watcher's timeout fan-out:** a burst like 04:50:04 (four comment sources plus this one) still won't reach that watcher's threshold of five distinct sources. Counting it would be a small follow-up if wanted; I did not post a job for it.

**Possible gap, not changed:** `comment-watcher.sh`'s timeout branch has no such admission-refusal handling. A timed-out comment source with refusal text could reach its primary-quota check. I read this in the code but did not reproduce it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-issue-source-timeout-degrade.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (618022 cached reads)
- Output: 16454 tokens
- Cost: $1.2800124
- Wall-clock: 524s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
