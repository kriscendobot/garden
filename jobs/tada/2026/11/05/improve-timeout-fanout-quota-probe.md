Implemented and pushed commit `33e34cb4fd9` to `main2`.

- Timeout fanout now samples REST core quota under the shared cooldown lock.
- Exhausted quota arms the reset-aware primary-quota latch instead of the generic cooldown.
- Added regression coverage proving later sources are not issued.
- Verified shell syntax, clean diff, and direct exhausted-quota behavior. The full watcher suite began passing but was not completed within the worker lease.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-timeout-fanout-quota-probe.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 200s

<!-- garden-usage-end -->
