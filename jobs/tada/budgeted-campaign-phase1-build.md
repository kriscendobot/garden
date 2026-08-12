Implemented and pushed commit `083cfb95ff` to `main2`.

- Added `--budget-tokens` and `--resume-from`, fresh CostRecord aggregation, fail-closed `budget-meter-incomplete`, `budget-exhausted`, visible parked/unspent reporting, and atomic separately-budgeted resume.
- Updated orchestration documentation and added all Phase 1 acceptance coverage.
- Verification: `orchestrate-test.sh` passed 25/25; shell syntax and diff checks passed. The expanded suite fails against pre-change code at the missing flag, confirming regression coverage is load-bearing.
- Pre-launch snapshot: 0 spent of 2,080,000; 2,080,000 unspent; 0 overshoot; 0 engagements.
- Launched all 29 Ironhorse children successfully. `jobs/orch/ironhorse-test262-implementation-completion-resume.md` is `state: running`; child 7 is in `doin/`.
- Follow-up: the deliberate garden deployment remains pending; the deployed watcher was still pre-change when it promoted child 7. The upgrade must deploy before the next serial promotion for budget enforcement.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/budgeted-campaign-phase1-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 803s

<!-- garden-usage-end -->
