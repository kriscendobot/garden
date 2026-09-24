Completion report: improve-comment-latency-primary-quota-cooldown

`scripts/jobs/comment-latency-watch.sh` now respects the shared GitHub API cooldown and stops its sweep when a source hits GitHub's primary quota. The updated test passes. Pushed to `main2` as b20b86cd54. I did not run the real GitHub-backed sweep; it is only covered by the stubbed test below.

**What changed in the script:**
- **Before collecting:** it checks `api_cooldown_active rest` first. If a cooldown is live, it writes a `cooldown` heartbeat and exits 0 without calling any source. `rest` is the right scope because every source it reads uses the REST API.
- **When a source reports primary-quota exhaustion:** each source handler now runs through a new wrapper, `run_source_handler`. The wrapper passes the handler's stderr through unchanged and checks it with `is_gh_primary_rate_limit_text`. It checks even when the handler exits 0, because `mention-source-gh.sh` hides its own failures. On a match:
  - the remaining sweep stops (the per-repo comment loop, issue-inbox and mentions);
  - the shared cooldown is set with `start_api_cooldown "comment-latency-watch:primary-quota" "$(api_primary_quota_secs)"`, which is one hour by default;
  - it writes a `cooldown` heartbeat and exits 0.

  Before this, the watch made one doomed 403 request per watched repository and the systemd unit failed on every run.
- **`--report-only` mode:** it follows the same cooldown behaviour but writes no heartbeat.

**Tests (`scripts/jobs/test/comment-latency-watch-test.sh`):**
- The test runs now use their own temporary `GARDEN_API_COOLDOWN_DIR`. Previously they would have read the host's real cooldown marker, and after this change they could have set it.
- A new scenario checks that:
  - a source that hits the primary quota exits 0, writes a `cooldown` heartbeat, sets a cooldown of at least 3600s, and sends no notices;
  - the next run makes no source calls while the cooldown lasts;
  - sweeping resumes, with a `full-poll` heartbeat, once the cooldown is cleared.

**Docs:**
- `designs/comment-latency-watch.md` §5 has a new "GitHub quota" bullet.
- In `CLAUDE.md`, the latency-watch paragraph lists the files the watch writes. It now includes the shared gh-api cooldown marker.

**Follow-ups:** none required. One trade-off: the search API has its own rate limit but GitHub reports it with the same "rate limit exceeded" message. If the search call behind mentions runs out, the watch would pause all REST watchers on the host for an hour.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-comment-latency-primary-quota-cooldown.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1543789 cached reads)
- Output: 12915 tokens
- Cost: $1.3089058
- Wall-clock: 121s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
