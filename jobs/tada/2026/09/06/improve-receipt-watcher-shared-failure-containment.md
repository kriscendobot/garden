Implemented and pushed `61156b7141` to `main2`.

- Receipt watchers now convert transient journal/`gh` failures and timeouts into shared, bounded cooldown skips with one fleet diagnostic.
- Persistent structural failures still exit nonzero with captured stderr.
- Added concurrent, fresh-clone, timeout, and structural-failure coverage.

Verification: receipt watcher tests 8/8 passed; core suite 383/383 passed. The independent fetch-timeout suite retains one pre-existing `ensure_clone` assertion failure (17/18 passed).

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-receipt-watcher-shared-failure-containment.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 507s

<!-- garden-usage-end -->
