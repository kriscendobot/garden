Fixed and pushed to `main2` as commit `6a518531af0`: a lost CAS on the snapshot publish now gets three real retries with seconds-scale jitter before the scaler warns.

**What was actually wrong.** `budget_publish_local_pool` already re-synced, re-rendered and retried after a lost CAS. But it allowed only 3 pushes in total, and the gaps between them came from the shared `backoff()` (base 50ms), so 0–50ms and then 0–100ms. Every host publishes near the same quarter-hour mark, so all the attempts landed in the same burst of journal writes and lost together. That matches the times in the job (19:17, 08:02, 16:17, 07:47, 03:47). This host's scaler log shows the 03:47:24Z WARN with `pool=claude-endolin1, push-class=cas`.

**What changed**
- **`scripts/jobs/usage-meter.sh`:**
  - `GARDEN_BUDGET_PUBLISH_ATTEMPTS` now defaults to **4**: the first push plus 3 retries.
  - The retries use their own full-jitter wait, `GARDEN_BUDGET_PUBLISH_BACKOFF_BASE_MS=1000` doubling to `_CAP_MS=8000`, so roughly 0–1s, 0–2s, then 0–4s. At most about 7s is added to a scaler tick that runs once a minute.
  - Each retry still re-syncs and rebuilds from the winning tip, reusing the reading already taken. The WARN fires only once all retries are used up.
- **New fixture `scripts/jobs/test/budget-snapshot-cas-retry-test.sh`:** against a real bare remote, a peer pushes first, so the publisher's first push is genuinely rejected and classified `cas`. The second push lands on top of the peer's commit. The test checks:
  - exactly 2 pushes;
  - one backoff, using the 1000/8000 window;
  - the peer's write is kept;
  - the warning latch is not set;
  - the 4-push default.
- **Three existing tests** (`budget-snapshot-publish-retry`, `-measure-first`, `-outage-reclone`) now set the new backoff variables to 0 so they don't sleep.

**Tests:** the new fixture passes, as do the publish-retry, measure-first, outage-reclone and warning-dedup tests. Two others fail: `budget-live-percent-label-test` (commit message assertion) and `live-budget-admission-test` (4 of 58 checks fail). They fail the same way on the unmodified base, so this change didn't cause them.

**Follow-ups**
- This host won't use the fix until the next deploy advances the root checkout.
- Those two failing tests may be worth their own job.
- Retries still happen after non-CAS failures (server-reject, definite-fail), as before. They're capped at 4 tries, so I left that alone.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-usage-meter-snapshot-cas-retry.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (1039789 cached reads)
- Output: 11836 tokens
- Cost: $1.1248538000000001
- Wall-clock: 223s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
