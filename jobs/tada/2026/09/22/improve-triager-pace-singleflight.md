Implemented and pushed commit `28ba4fd23acf` to `main2`.

- Added a host-wide, flock-protected pacing cooldown so concurrent triagers share one refresh window while others retain normal timer cadence without clone-lock warnings.
- Added fail-open behavior and a `GARDEN_TRIAGE_PACE_COOLDOWN=0` escape hatch.
- Added regression coverage for herd collapse and disabled-gate behavior.
- Verified: `triager-pacing-test.sh` passed 8/8; `bash -n` and `git diff --check` passed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-triager-pace-singleflight.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 91s

<!-- garden-usage-end -->
