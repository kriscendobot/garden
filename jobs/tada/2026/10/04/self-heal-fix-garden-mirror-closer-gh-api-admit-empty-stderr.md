I fixed the empty-stderr admission refusal in `gh_api_retry` and pushed it to `main2` as `8d4cec943bd`. Every refusal now leaves a line on stderr that callers can classify, so the mirror-closer should no longer die FATAL when a gh-api cooldown latch is live.

**What changed**
- **`scripts/jobs/common.sh`, `_gh_api_admit`:** on a refusal it now builds this message:
  `gh api <label> admission refused: host-shared gh-api cooldown live (<N>s left, tag <tag>; API rate limit already exceeded for user); not issued`
- **`scripts/jobs/common.sh`, `gh_api_retry`:** the refusal branch always prints that line to stderr before returning 75, whatever the `emit` flag says. `emit` now only controls the WARN line `_gh_api_admit` writes to the service log, so the log isn't spammed with repeats.
- **The quota phrase is always included,** even when the latch wasn't opened for the primary quota. Any live latch blocks the rest of the tick's calls the way an exhausted quota does. A caller that reacts by arming its own cooldown can't lengthen it, because `start_api_cooldown` never extends a live window. So the only effect is that the caller stops querying for the rest of the tick.
- **Caller code is unchanged.** The new text matches both `is_gh_primary_rate_limit_text` and `_gh_api_stderr_is_transient`. `mirror-pr-state-gh.sh` will now take its quiet quota-exit path instead of `die()`, and `comment-source-gh.sh` will treat the refusal as quota rather than a structural failure.
- **`scripts/jobs/test/gh-api-retry-test.sh`:** a new check runs 6 concurrent callers against a live latch, 5 of which are refused quietly. It requires all 6 stderr captures to carry the refusal line and to classify as both quota and transient. It fails on the old code (0/6) and passes with the fix.

**Tests:** all passing — `gh-api-retry-test.sh` 62/62, `mirror-closer-test.sh` 72/72, `api-cooldown-test.sh` 22/22, `comment-watcher-test.sh` 441/441, and `comment-latency-watch-test.sh`.

**Follow-ups:** none required. The fix takes effect on hosts at the next rolling deploy.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-mirror-closer-gh-api-admit-empty-stderr.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1090138 cached reads)
- Output: 8297 tokens
- Cost: $0.8369516
- Wall-clock: 1113s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
