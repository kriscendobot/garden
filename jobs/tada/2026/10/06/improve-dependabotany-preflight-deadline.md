Implemented and pushed commit `1574472ecab` to `main2`.

- Added a 110-second total preflight deadline.
- Clipped journal sync, PR-source, and compatibility stages to remaining time.
- Deadline exhaustion now returns `EX_TEMPFAIL` before the scheduler’s 120-second timeout.
- Added hanging-source regression coverage.
- Verified 38 dependabotany tests and 37 related scheduler tests pass.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-dependabotany-preflight-deadline.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 249s

<!-- garden-usage-end -->
