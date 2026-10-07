Implemented and pushed commit `56e994d1bcd` to `origin/main2`.

- Added bounded split-lineage metadata for indivisible expanded successors.
- A second wall hit now parks the job with a deduplicated, actionable notice instead of recursively splitting again.
- Preserved the original work body and compatibility with existing expanded successors.
- Added regression coverage for the second wall hit, lineage, notice, and body preservation.
- Verification: relevant suites passed 24/24, 12/12, 35/35, and 42/42; syntax, diff, and shell checks completed without errors.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-bound-recursive-deadline-splits.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 418s

<!-- garden-usage-end -->
