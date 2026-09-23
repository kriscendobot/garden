Implemented and pushed commit `ea1b959677` to `main2`.

- Added guarded, ancestor-safe, bounded cgroup straggler reaping to `receipt-watcher.sh`.
- Added the 3-second `GARDEN_RECEIPT_CGROUP_REAP_DEADLINE_SECS` default.
- Added fixture-based wait-until-empty regression coverage.
- Verified with `scripts/jobs/test/receipt-watcher-test.sh`: 10 passed, 0 failed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-receipt-watcher-kriscendobot-moddable-cgroup-straggler-reap.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 420s

<!-- garden-usage-end -->
