Routed comment-watcher self-test reads through `gh_api_retry` while preserving the 10s/5s timeout bound. Added regression coverage proving primary-quota exhaustion latches after the first request and suppresses the fallback probe.

Verification: `comment-watcher-test.sh` passed all 479 tests; Bash syntax checks passed. Pushed commit `fc6b5e12b72` to `main2`.

Follow-ups: none.
Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-comment-watcher-quota-admission.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 991s

<!-- garden-usage-end -->
