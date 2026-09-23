---
orchestration-failed: true
---
Posted the substantive Ironhorse summary to garden issue 51: https://github.com/kriscendobot/garden/issues/51#issuecomment-5298964170

Reported:

- Before/after full-suite totals and exact revision pins.
- PR #970 and all 28 predecessor reports/orchestrations.
- Independently parsed public JSON totals.
- Independently reran the official Proxy slice with XS: 188 covered, 121 unsupported, 1 skipped, 1 infrastructure, 0 failures.
- Rechecked metering corpus: 1,711 covered, 0 failed/skipped.
- Residual clusters, regressions, exclusions, and infrastructure caveats.

No source changes were made. PR #970 remains open and draft; issue 51 remains open. The acceptance gate remains unmet because residual closure is still running and the measured checkpoint contains failures, infrastructure results, and six covered-case regressions. A post-closure full-suite refresh remains necessary.

Self-improvement: nothing this time.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ironhorse-js-28-issue-summary.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 393s

<!-- garden-usage-end -->
