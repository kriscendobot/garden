Implemented and pushed commit `04055d337fa` to `main2`.

- Added exact `panel_head` checks immediately around un-drafting.
- Added an independent driver gate requiring matching `headRefOid` and `isDraft=false` before completion.
- Stale heads, malformed metadata, and still-draft PRs now halt fail-closed.
- Extended the hermetic GitHub stub and regression coverage.

Tests: `gauntlet-test.sh` reported 71 passed, 0 failed; syntax and diff checks passed.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-gauntlet-undraft-head-gate.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 423s

<!-- garden-usage-end -->
