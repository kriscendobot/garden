Implemented and pushed commit `5476cd1e78` to `main2`.

- `promote-plan.sh` now blocks orchestrated `*-shepherd-*` children lacking `role: shepherd` or an equivalent long-running handler budget.
- Added a 9-case hermetic regression test.
- Verified promotion reset (32 tests), annotation (45), and orchestration (51) suites.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-orchestrated-shepherd-budget.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 312s

<!-- garden-usage-end -->
