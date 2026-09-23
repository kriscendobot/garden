Implemented and pushed commit `897d6beecb0` to `main2`.

- Hardened cursor outage latching so a late successful read cannot erase a newer correlated outage.
- Preserved bounded cooldown recovery and disabled-cooldown cleanup.
- Added deterministic race coverage; cursor outage suite passes 38/38.
- Broader checks exposed unrelated existing failures in two gauntlet test suites.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-cursor-read-herd-suppression.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 230s

<!-- garden-usage-end -->
