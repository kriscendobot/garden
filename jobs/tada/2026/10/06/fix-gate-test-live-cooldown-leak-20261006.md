Landed on `main2` at `a3d92403626`.

- Isolated every candidate-gate suite in private per-suite state, including API cooldown, journal outage, CI outage, and CI source-cache latches.
- Isolated `triager-pacing-test.sh` and added a fake live-root cooldown regression.
- Added deploy-gate coverage confirming host latches remain untouched and invisible to suites.
- Verified: `triager-pacing-test.sh` — 14 passed; `deploy-garden-test.sh` — 182 passed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-gate-test-live-cooldown-leak-20261006.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 485s

<!-- garden-usage-end -->
