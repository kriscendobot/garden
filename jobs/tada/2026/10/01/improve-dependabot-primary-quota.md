**Completion report: improve-dependabot-primary-quota**

The dependabot watcher now waits out GitHub's hourly reset when it hits GitHub's primary hourly API quota, instead of retrying after 5 minutes. The fix is pushed to `main2` as `41533558aa4`, and the watcher's test suite passes (62 passed, 0 failed).

**The problem:** a primary-quota refusal (`API rate limit exceeded`) from the open-PR source matched the generic "transient" check. That check only opens a 300s cooldown, so the next tick retried a call that was certain to fail again within the same quota hour. This is what the 2026-10-01T12:41:50Z warning showed.

**Changes:**
- **`scripts/jobs/dependabot-watcher.sh`:** added a primary-quota branch before the generic transient one, copied from the one in `ci-watcher.sh`. When the source's stderr shows a primary-quota refusal, the watcher:
  - asks for the full `api_primary_quota_secs` window;
  - arms the host-wide cooldown latch under the tag `dependabot:<slug>:source`, which pauses all gh-api watchers on the host;
  - logs a "primary REST quota exhaustion" warning and exits 0 without posting anything.

  It uses the host-wide latch, not the GraphQL-only one, because this source is the REST pulls list, so the refusal proves the REST bucket is spent.
- **`scripts/jobs/test/dependabot-watcher-test.sh`:** added case Q. It stubs a primary-quota refusal and checks that:
  - the watcher exits 0 and logs the primary-quota warning rather than the generic one;
  - the host-wide marker lasts at least 3600s, not 300s;
  - the latch carries the right owner tag and no job is posted;
  - a later tick 600s into the window skips without calling the source.

No follow-ups. The fix reaches each host on the next rolling deploy.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-dependabot-primary-quota.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (561790 cached reads)
- Output: 6029 tokens
- Cost: $0.718466
- Wall-clock: 88s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
