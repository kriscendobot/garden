Completed and pushed commit `b9a0411e52f` to `main2`.

- Added a required PR phase/evidence ledger for ordered designs, with explicit deliverable and non-deliverable-probe dispositions.
- Added an authoring-time `ensure-pr.sh` gate and durable panel gate. Blocked findings force the integrator seat and mechanically bind the panel disposition to `must-fix`.
- Re-litigated PR 87 using its body and exact `b6280ed36d` diff. The gate exited 20, identified phases 1-6 plus missing production evidence and open prerequisites, and the panel returned `must-fix` despite approving stubs.
- Verification passed: phase-evidence tests (13/13), ensure-pr tests (32/32), related-design tests (21/21), ownership-map tests (6/6), ShellCheck, syntax checks, and all panel test scripts.
- Closed cluster `phase-slice-substitutes-for-production-evidence` with `improved_by: b9a0411e52f ...`.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/review-improve-phase-slice-substitutes-for-production-evidence.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 946s

<!-- garden-usage-end -->
