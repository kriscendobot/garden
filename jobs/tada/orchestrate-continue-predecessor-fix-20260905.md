Landed `1c07bf937d` directly on `main2`.

- Serial `continue` promotions now distinguish completed and failed predecessors while preserving CAS revalidation.
- Added `promote-plan.sh --require-failed` for terminal failures.
- Added doom-park, vanished-child, multi-child sequencing, and stale-snapshot regressions.
- Verification: orchestration 53/53; promotion suites 32/32 and 9/9; full jobs suite 383/383.
- Self-improvement: nothing this time.
- Follow-ups: none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/orchestrate-continue-predecessor-fix-20260905.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 591s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
