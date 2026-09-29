The CI watcher now waits out the full quota window (3600s by default) when its PR source is refused for GitHub's primary quota, instead of retrying after the short 300s cooldown. The fix is pushed to `main2` as `f26efdea35f`.

**What was wrong:** at `scripts/jobs/ci-watcher.sh:483`, the refusal from 2026-09-29T18:38:35Z fell into the generic "transient" branch, because its text also matches the transient list. That branch opens only a 300s cooldown. After 300s the next tick polled the source again, even though the quota could not have recovered within the same hour.

**What changed:**
- **`scripts/jobs/ci-watcher.sh`:** when the PR source fails, the watcher now checks `is_gh_primary_rate_limit_text` before the transient check. On a match it calls `start_api_cooldown "ci:$slug:source" "$(api_primary_quota_secs)"`, which pauses every gh-api watcher on the host for the full quota window. It logs one "primary REST quota exhaustion" warning and exits 0.
  - The source reads the REST pulls list, so this uses the host-wide marker, not the GraphQL-only marker that the rollup check (`rollup_hit_primary_quota`) uses.
  - The source-failure checks still run in this order: network errors, then primary quota, then other transient errors, then deleted repo, then fatal.
- **`scripts/jobs/test/ci-watcher-test.sh`:** a new `QUOTA` case uses a source that fails with the real error wording ("API rate limit already exceeded for user ID … (HTTP 403)"). It checks that the watcher:
  - exits 0 and logs the primary-quota warning;
  - sets the host-wide marker to expire at least 3600s out, with the tag `ci:<slug>:source`;
  - leaves the GraphQL-only marker untouched;
  - skips the source entirely on a later tick 600s into the window, which is past where the old 300s cooldown would have ended.

**Tests:** the whole `ci-watcher-test.sh` suite passes (103 passed, 0 failed). With the watcher fix reverted, the four new quota assertions fail, so the test does catch the original bug.

No follow-ups.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-ci-primary-quota-source.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (635628 cached reads)
- Output: 6734 tokens
- Cost: $0.7731416
- Wall-clock: 186s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
