---
handed-off: resolve-endo-pr1349-depcheck-ci-20261028
deliverable-complete: false
---
Confirmed and force-restored #1349 to `2262b4bafa`; the removed commit changed only `depcheck.yml`. #1582 retains the Ubuntu 24.04 pin and is fully green. Re-staged the authorized ferry directive at journal commit `5e310485c7` and did not run it.

#1349’s main CI is green, but depcheck fails because `ubuntu-latest` lacks `tred`. Asked the maintainer for disposition and parked successor `resolve-endo-pr1349-depcheck-ci-20261028`, which owns the remaining CI/ferry update.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-endo-pr1349-stray-depcheck-20261028.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 870s

<!-- garden-usage-end -->
