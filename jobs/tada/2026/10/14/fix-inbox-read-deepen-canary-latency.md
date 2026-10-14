Implemented and pushed commit `d43e3363018` to `main2`.

- Added a default-on `sync_clone` deepen toggle.
- Disabled deepening for `inbox-read.sh`, including canary probes.
- Added regression coverage proving fresh inbox clones never run `--unshallow`.
- Preserved deepening for history-walking readers.
- Verification: targeted suite passed 19/19; Bash syntax and diff checks passed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-inbox-read-deepen-canary-latency.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 108s

<!-- garden-usage-end -->
