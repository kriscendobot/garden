Implemented and pushed commit `b67de8ea663` to `main2`.

- Dedup scans now fail closed on any nonzero paginated `gh` read, including partial-output failures.
- Added regression coverage proving partial reads cause zero POSTs.
- Traced `cid=1601` to an unstubbed test helper that invoked the real reply handler with synthetic fixture data. The helper now uses the reply stub and verifies a real GitHub comment ID reaches reactji/reply handlers.
- Added a test-context guard preventing accidental real GitHub replies from tests.
- Existing comments on endojs/endo-but-for-bots#600 were untouched.
- Verification: syntax and diff checks passed; relevant new regressions passed. Full watcher suite reported 371 passes and two unrelated pre-existing failures (`BQ`, `MP2b`).
- Self-improvement: `comment-reply-gh.sh`; added a test-context mutation backstop after tracing the synthetic ID to an unstubbed test sink.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-comment-reply-dedup-fail-open-20260923.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 550s

<!-- garden-usage-end -->
