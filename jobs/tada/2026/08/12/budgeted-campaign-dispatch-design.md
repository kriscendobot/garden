Created and landed `designs/budgeted-campaign-dispatch.md` on `main2` at commit `67e6b0d88246`.

The design specifies a same-day Phase 1: `--budget-tokens`, fresh CostRecord aggregation before serial promotion, explicit budget-exhausted and meter-incomplete outcomes, parked remainder, visible unspent budget, and separately budgeted resume. Phase 2 covers transitive campaign tags and per-account caps.

Recomputed the current allocation as 2.08M billable tokens, approximately $68.06 notional and $20.73 real-dollar-equivalent at the current 3.28x index. The design discloses 95 unmetered rows and the workload-dependent discrepancy with earlier 2.8x and 8.7x estimates.

Added library keyword shortcuts for CostRecord/notional-ledger and coding-agent-spend concepts, then notified the scholar.

Verification: all five deterministic pre-push probes passed; remote `main2` resolves to `67e6b0d88246`.

Follow-up: implement Phase 1, then post the restored 29-child Ironhorse resume with `--budget-tokens 2080000`.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/budgeted-campaign-dispatch-design.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 731s

<!-- garden-usage-end -->
