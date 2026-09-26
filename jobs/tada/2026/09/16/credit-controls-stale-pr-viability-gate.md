Implemented and pushed `c32821fa15` to `main2`.

- Added a pre-spend PR viability stage covering open/merged state, supersession, and premise validity.
- Overtaken PRs now surface the deciding question and “close as superseded”; malformed verdicts fail closed.
- Added regression coverage. All 11 check suites passed; mutation testing confirmed the new test is load-bearing.
- Follow-up: child 4 remains parked because the parent orchestration previously halted on this stale claim.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/credit-controls-stale-pr-viability-gate.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 463s

<!-- garden-usage-end -->
