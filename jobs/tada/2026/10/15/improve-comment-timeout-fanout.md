Implemented and pushed commit `67477d18365` to `main2`.

- Added a locked, host-wide 60-second rolling detector for five distinct comment-source timeouts.
- Threshold crossings now open the shared API cooldown and emit one episode warning.
- Isolated and repeated same-slug timeouts retain independent exponential backoff.
- Added regression coverage for stale-event pruning, distinct-slug counting, cooldown activation, warning deduplication, and retained per-slug state.
- Verification: `comment-watcher-test.sh` passed all 484 tests; Bash syntax and `git diff --check` passed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-comment-timeout-fanout.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1125s

<!-- garden-usage-end -->
