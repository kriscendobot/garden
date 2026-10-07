Fixed comment-watcher cooldown admission handling. EX_TEMPFAIL refusals under an existing transient cooldown now freeze the cursor and exit quietly without promoting synthetic “API rate limit” text to a primary-quota latch.

Added regression coverage for the Pages network-latch race. `comment-watcher-test.sh` passed all 477 tests; syntax and diff checks passed.

Pushed commit `6091cc108a3` to `origin/main2`. No follow-ups required.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-comment-cooldown-admission.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 915s

<!-- garden-usage-end -->
