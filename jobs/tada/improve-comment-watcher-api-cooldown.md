Implemented and pushed commit `2bc08ac82d` to `main2`.

Added a host-shared, lock-protected GitHub API cooldown for comment watchers. The first 5xx/HTML/rate-limit failure records a bounded 300-second window and emits one warning; sibling repo ticks skip quietly without advancing cursors or guessing state. The window is configurable, capped at 15 minutes, and never extended by sibling failures.

Added regression coverage for initial warning consolidation, quiet sibling skips, and expiry/re-arming. All seven new assertions passed. The full watcher suite reported 282 passes and three unrelated existing failures in its missing-`jq` test because `common.sh` restores `/usr/bin` to `PATH`. Syntax and diff checks passed.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-comment-watcher-api-cooldown.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 329s

<!-- garden-usage-end -->
