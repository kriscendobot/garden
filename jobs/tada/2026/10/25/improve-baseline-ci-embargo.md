Implemented and pushed commit `641bae7ab28` to `main2`.

- Added bounded, fail-open comparison of Dependabot PR and exact-base CI rollups.
- Jobs now carry immutable SHA/count evidence for shared failures; fully shared failures instruct botanists to avoid repeated diagnosis/shepherding and record an infrastructure-blocked embargo/recheck.
- Added configurable limits: four comparisons per tick, 45-second timeout, and a 100-context ceiling.
- Added handler and watcher coverage for full/partial overlap, no proof, pagination bounds, and comparison caps.
- Verification: handler tests 4/4 passed; watcher tests 73/73 passed; shell syntax and `git diff --check` passed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-baseline-ci-embargo.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 392s

<!-- garden-usage-end -->
