Implemented and pushed commit `c9bdc1fba65` to `main2`.

- Snapshots validated job/report inputs before panel-freshness processing.
- Missing inputs now produce an actionable retryable diagnostic and retain the claim instead of emitting sensor usage.
- Added regression coverage for successful-handler/missing-input behavior.
- Passed syntax checks, panel freshness tests, and the new completion regression.
- Broader completion-signal suite was stopped after 11 minutes due unusually slow host-wide usage scans.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-gardener-panel-freshness-inputs.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 885s

<!-- garden-usage-end -->
