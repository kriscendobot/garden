I found why the shared cooldown never opened and fixed it. The fix is pushed to `main2` as `892bc5a08fe`.

**Why it failed.** The host-wide fanout ledger was shared and locked correctly; the problem was its time window. It only counted timeouts from the last 60 seconds (`GARDEN_COMMENT_TIMEOUT_FANOUT_WINDOW_SECS=60`). Each repo's watcher runs every 90 seconds plus up to 30 seconds of random delay, so one round of timeouts across different repos can be spread over about 120 seconds. The five timeouts in the incident ran from 06:47:38Z to 06:48:56Z, 78 seconds in all, so no 60-second window ever held five. Each source took a local strike and the old entries were dropped from the ledger. The 06:50:57Z finbot event was the only one left in `.garden-state/comment-watcher/source-timeout-fanout/events` when I looked.

**What changed.**
- `scripts/jobs/comment-watcher.sh`: the default window is now 180 seconds, including the fallback used when the setting is malformed. A comment explains the timer arithmetic and the incident. 180 seconds is still shorter than the 300-second backoff after a repo's first timeout, so one repo can't be counted twice in a window.
- `scripts/jobs/test/comment-watcher-test.sh` has two new regression tests, and both pass:
  - **Incident replay:** recreates the 78-second spread with the default window and checks that the fifth repo opens the shared cooldown and logs "within 180s".
  - **Concurrent instances:** starts five watchers for different repos at the same moment, with a barrier that releases all their sources together. It checks that they share one ledger and open exactly one cooldown, with one fanout warning and four local strikes. It also checks that the ledger is cleared afterwards and each repo still has its own backoff record.

**Test results.** The full suite gave 485 passed, 4 failed. The four failures are in sections that don't go through the timeout-fanout code:
- three in FAN, where the comment source missed its 5-second deadline (rc=124);
- one in VBUSY, "replay acknowledgment was not exactly once".

The host load average was about 54 during the run, so these look like load-related timing failures. I didn't confirm that by running the same suite on the unchanged `origin/main2`.

**Follow-up.** The fix only takes effect on a host once the rolling deploy brings the root checkout up to `892bc5a08fe`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-comment-timeout-fanout.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 36 tokens (1255407 cached reads)
- Output: 12716 tokens
- Cost: $1.1071534 (1 engagement(s) unpriced)
- Wall-clock: 2475s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
