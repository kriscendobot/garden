Implemented and pushed commit c213b02e83 to main2.

- Added deterministic ordinary-job overrun splitting through orchestration, including divisible and indivisible paths.
- Added completion validation, ledger decisions, and explicit larger-timeout reasoning.
- Excluded gauntlet-internal stages from generic retry/split handling.
- Added deterministic boundary tests.
- Verification: full suite passed, 386/386; pre-push gates and syntax checks passed.
- Follow-up: standalone legacy `gauntlet-test.sh` has a pre-existing stale first-stage expectation not used by the passing full suite.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-cybernetics-overrun-split.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1399s

<!-- garden-usage-end -->
