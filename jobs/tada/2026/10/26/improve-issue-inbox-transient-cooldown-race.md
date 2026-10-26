**Completion report: improve-issue-inbox-transient-cooldown-race**

**Cause:** In `scripts/jobs/issue-inbox-watcher.sh`, the check for a collateral "admission refused: host-shared gh-api cooldown live" diagnostic only ran inside the `api_primary_quota_cooldown_active rest` branch. So when the latch was a plain transient one (the 2026-10-26 22:49:52 `pages:*:net` latch), the refusal skipped that check and reached `is_gh_primary_rate_limit_text`. That classifier matches because `gh_api_retry`'s synthetic refusal always says "API rate limit already exceeded". `start_api_cooldown` then turned the transient latch into a new, longer primary-quota episode (2489s) and logged a second warning.

**Fix (main2 `79377c2dbb4`):**
- An admission-refused diagnostic under **any** live REST cooldown (`api_cooldown_active rest`) is now treated as collateral. The watcher exits 0 with the cursor frozen and the heartbeat outcome set to `cooldown`. It does not change the latch's owner, kind or deadline, and it emits no warning.
- The fallback for an existing primary-quota latch with no admission refusal is unchanged. A raw `gh-api:` latch opened by this source's own request still goes through the adoption path; a latch already claimed by another watcher still exits quietly.
- I rewrote the comments to match the new order.

**Regression case (`scripts/jobs/test/issue-inbox-watcher-test.sh`):** A source stub opens a default-window transient `pages:kriscendobot-garden:net` latch, emits the synthetic admission refusal, and exits 75. The test asserts three things: the cursor stays frozen; the marker keeps tag `pages:kriscendobot-garden:net`, kind `transient` and the original expiry; and the watcher logs no warning.
- On the old watcher it fails with the incident's exact symptoms: the latch was promoted to `issue-inbox:…:primary-quota <- pages:…:net` and a warning was emitted.
- On the fixed watcher it passes.

**Tests:**
- `issue-inbox-watcher-test.sh`: 74 passed, 0 failed.
- `issue-inbox-tick-bounds-test.sh`: 23 passed, 0 failed.
- `issue-inbox-journal-linkage-test.sh`: 17 passed, 0 failed.

**Follow-ups:** None. `ci-watcher.sh` already runs this check before classifying, so it doesn't have this bug.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-issue-inbox-transient-cooldown-race.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1171360 cached reads)
- Output: 11027 tokens
- Cost: $1.0301960000000001
- Wall-clock: 323s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
