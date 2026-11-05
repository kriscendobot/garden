Backfilled `receipts/rollup.jsonl` on `journal2` for all 209 archived receipts.

- Rollup rows: 28 before → 209 after (181 added).
- Computed and reused one cost base map for the entire run.
- Skipped PRs: none. All 26 transient API failures succeeded on paced retry.
- Verified 209 schema-1 rows, 209 unique repo/PR pairs, and zero missing or extra pairs.
- Archived receipt Markdown remained unchanged.
- CAS rebase/push completed; remote `journal2` contains the full rollup.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/backfill-receipt-rollup-20261105-expanded-window.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 5217s

<!-- garden-usage-end -->
