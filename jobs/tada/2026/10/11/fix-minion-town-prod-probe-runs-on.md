---
handed-off: fix-minion-town-prod-probe-runs-on-validation
deliverable-complete: false
---
Implemented commit `17e4d3c`, switching both prod-probe jobs to the shared `CI_RUNS_ON` expression, and opened draft PR #182.

Verification:

- `npm run typecheck` passed.
- Production-probe tests passed, 16/16.
- PR CI run 38164494531 passed all three jobs on the self-hosted runner.
- Gauntlet `kriscendobot-minion.town-pr182-gauntlet` is staged; PR remains draft pending review, merge, and production execution.
- PR #171 still uses `ubuntu-latest` for its harness, probe, and report jobs; its next fix round should adopt `CI_RUNS_ON`.

Posted successor `fix-minion-town-prod-probe-runs-on-validation` to own gauntlet completion, delegated merge, workflow dispatch, and honest production-probe reporting.

Self-improvement: nothing this time.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-minion-town-prod-probe-runs-on.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1729s

<!-- garden-usage-end -->
