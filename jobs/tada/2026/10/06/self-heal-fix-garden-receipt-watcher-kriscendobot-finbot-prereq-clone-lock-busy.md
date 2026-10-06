Implemented and pushed commit `7e195b499b2` to `main2`.

- Receipt watcher now skips live-peer clone-lock contention without triggering gh-api cooldown; definite failures remain loud.
- Applied equivalent handling to the only other affected watcher, `repo-watcher.sh`.
- Added regression coverage for both watchers.
- Verified syntax, clean diffs, contention classification, no-FATAL/no-cooldown receipt behavior, and repo-watcher’s clean skip. Broader suites exposed unrelated existing failures.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-receipt-watcher-kriscendobot-finbot-prereq-clone-lock-busy.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 458s

<!-- garden-usage-end -->
