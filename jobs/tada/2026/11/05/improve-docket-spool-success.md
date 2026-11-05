Implemented and pushed `1dd5dbe16ca` to `main2`.

- `review-docket-request.sh` now treats the configured legacy spooled RC (default 76) as successful deferred intake and logs the normalization.
- Added regression coverage for immediate success, default/configured spooled RCs, and hard-failure propagation.
- Passing: new request-adapter test, fixer docket completion test, ShellCheck, and diff checks.
- Follow-up: the existing full docket test independently failed its hung-push retry-count assertion in two runs; this path was unchanged.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-docket-spool-success.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 662s

<!-- garden-usage-end -->
