Implemented and pushed commit `42863eb06db` to `main2`.

- Decision-ledger appends now use one configurable short, soft clone-lock wait and fail open through the existing outage latch.
- Added regression coverage confirming live contention returns promptly, avoids `FATAL`, and records the dropped append.
- Verified: decision-ledger tests pass, 17/17; Bash syntax and `git diff --check` pass.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-decision-append-lock-contention.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 311s

<!-- garden-usage-end -->
