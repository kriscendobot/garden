Implemented and pushed receipt-watcher cgroup cleanup to `main2`.

- Added bounded wait-until-empty descendant reaping with the receipt-specific deadline and test fixture.
- Restricted production sweeping to `garden-receipt-watcher@*.service`.
- Verified `receipt-watcher-test.sh`: 11 passed, 0 failed.
- Commit: `36750325dfc59a5d343a84ef28deda2e58f223bd`
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-triager-kriscendobot-minion-town-receipt-watcher-cgroup-reap.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 186s

<!-- garden-usage-end -->
