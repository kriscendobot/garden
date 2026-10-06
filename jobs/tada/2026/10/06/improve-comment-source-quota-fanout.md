## Report: improve-comment-source-quota-fanout

The review-metadata fanout in `scripts/jobs/handlers/comment-source-gh.sh` now checks REST quota before it sends any requests. A quota refusal now costs at most one request, where the 2026-10-06T15:58:36Z incident cost eight. The full `comment-watcher-test.sh` suite passes (471 passed, 0 failed), and the change is pushed to main2 as `da16ba4564f`.

**What changed in the handler:**
- **Quota check first.** Before fanning out, the source asks GitHub how much REST quota is left (`gh api rate_limit`, which does not count against the quota).
  - If the remaining count is at or below the reserve, no review-metadata request is sent. The reserve is set by `GARDEN_COMMENT_REVIEW_QUOTA_RESERVE` and defaults to 100.
  - Otherwise, both the number of PRs polled and the concurrency are capped at what the spare quota can pay for. Each PR costs 2 calls, or 3 when the fork has Issues turned off.
  - If the walk would need more PRs than that, it stops early and logs which PRs were not polled.
  - In every stop case the cursor stays frozen (rc 75) and the shared cooldown opens. The cooldown is shortened to GitHub's reported reset time when that is sooner than the default window.
- **First worker runs alone.** The first PR's worker always runs by itself, and the other workers start only after it returns without a quota refusal. So if the quota check is wrong or unavailable (for example, another host used the quota after the check), only one request is refused.

**What changed in the fixture (`scripts/jobs/test/comment-watcher-test.sh`, RATE section):**
- A new test runs eight active PRs at concurrency 8 and checks three cases:
  - **Quota check says plenty is left, but every request is refused:** exactly one refused request, rc 75, and the cooldown opens.
  - **Remaining quota at or below the reserve:** zero per-PR requests, and the cooldown ends at the reported reset.
  - **Spare quota pays for only 3 PRs:** exactly 3 PRs are polled, concurrency never goes above 3, rc 75, and the "not polled" log line appears.
- The existing late-quota test is tighter: it now requires exactly one per-PR request (the first worker's) and no request for PR #2.

**Incident during testing:** my first test run wrote a primary-quota cooldown into the live host state at `/home/kris/garden/.garden-state/gh-api-cooldown/marker`. The test doesn't set the cooldown directory and `GARDEN_ROOT` came from the environment, so it pointed at the live root. That cooldown lasted 120 seconds, so for up to two minutes around 16:27Z it could have blocked this host's `gh` calls. It expired and was cleaned up, and I confirmed the file is gone. The new test now sets its own cooldown directory, and the second run left no trace.

**Follow-ups:**
- Other tests in the same RATE section may also not set the cooldown directory, which would give them the same leak. They're worth a check.
- Every comment-watcher tick that has active PRs now makes one extra `gh api rate_limit` call. It doesn't use quota, but it does add one round trip.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-comment-source-quota-fanout.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1220109 cached reads)
- Output: 14742 tokens
- Cost: $1.2086217999999997
- Wall-clock: 978s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
