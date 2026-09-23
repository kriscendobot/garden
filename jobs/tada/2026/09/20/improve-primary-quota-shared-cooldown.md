Pushed successfully. Job complete.

## Completion report

**Problem.** When a GitHub *primary* hourly-quota refusal occurred, the shared host-wide gh-api cooldown (`common.sh` `start_api_cooldown`) was always armed for the short **300 s** transient-blip default. The primary bucket cannot recover before its hourly reset, so mirror-closer armed a 300 s shared window on a quota trip and **ci-watcher then retried a known-doomed API call inside the same quota hour** — the incident named in the spec.

**Changes** (all on `main2`, commit `91eb85cb75f`):

- `scripts/jobs/common.sh`
  - `start_api_cooldown` now accepts an optional **`[requested-secs]`** second argument (mirrors `start_provider_cooldown`): a valid request sets the window, clamped to the new `GARDEN_API_COOLDOWN_MAX_SECS` (default **7200**) and floored at 1 s. With no request the short `_api_cooldown_secs` default (≤900 s) still applies, and the `secs=0` disable escape hatch still wins.
  - Added `_api_cooldown_max_secs` and `api_primary_quota_secs()` (default **3600 s**, env `GARDEN_API_PRIMARY_QUOTA_SECS`, clamped to the cap) — the shared "one hour for primary quota" policy any detector requests. Updated the header comment.
- `scripts/jobs/mirror-closer.sh` — its `start_mirror_quota_cooldown` now arms the shared latch for `mirror_quota_cooldown_secs` (the **same one-hour window** as its own primary-quota marker) instead of the 300 s default.
- `scripts/jobs/ci-watcher.sh` — `rollup_hit_primary_quota` (the other primary-quota detector, and the incident's victim) now requests `api_primary_quota_secs`, so whichever watcher detects primary quota first arms an hour-long shared latch that protects everyone else's doomed retries.

**Tests.** Extended `test/api-cooldown-test.sh` (requested window honored, clamped to 7200, non-numeric falls back to the short default, disable hatch still no-ops) and `test/mirror-closer-test.sh` H1d (asserts the shared latch is now the full hour, not 300 s). All green: api-cooldown 11/11, mirror-closer 66/66 (incl. live E2E), ci-watcher 74/74. Syntax-checked; shellcheck clean on the changed regions (the two SC warnings are pre-existing, unrelated code at line 4943).

**Follow-ups.** None required. Other watchers that arm the shared cooldown for genuinely *transient* blips (comment-, dependabot-, approval-, issue-inbox-, receipt-) correctly keep the short default — they don't classify primary quota, so no change was warranted there.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-primary-quota-shared-cooldown.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1725996 cached reads)
- Output: 18381 tokens
- Cost: $2.0651809999999995
- Wall-clock: 335s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
