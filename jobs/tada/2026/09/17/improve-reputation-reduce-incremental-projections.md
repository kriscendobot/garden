Implemented and pushed commit `1c60aa15c62b` to `main2`.

- Reducer now tracks changed arms, bounds pending/discovery/event batches, and resumes from checkpoints.
- Only affected projections are recomputed; rate or policy changes trigger bounded rescans.
- Added incremental/resume CI coverage and corrected an idempotence test snapshot.
- Verified: incremental tests 6/6, auction/reputation tests 73/73, related reputation suites 93/93, changed-file ShellCheck clean.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-reputation-reduce-incremental-projections.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1227s

<!-- garden-usage-end -->
