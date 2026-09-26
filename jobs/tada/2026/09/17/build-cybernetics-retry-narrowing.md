Implemented and pushed commit `30f130d39a` to `main2`.

- Added one delayed retry for ordinary non-productive, non-quota exits.
- Made first wall overruns immediately split-eligible.
- Preserved quota back-off, productive resets, gauntlet behavior, and doom spooling.
- Recorded retry and recovery decisions in the ledger.
- Added deterministic regression coverage and deploy gating.

Verification: retry tests 10/10, deploy tests 132/132, full suite 386/386, ShellCheck and syntax checks passed.

Follow-ups: none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-cybernetics-retry-narrowing.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 1450s

<!-- garden-usage-end -->
