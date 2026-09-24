Fixed `write_stats()` to return cleanly when a sample directory is empty and reuse only matched sample paths for both `awk` calls. Added regression coverage for an active repo with an empty sample directory.

Landed commit `fe18c49534` on `main2`.

Verification:
- `bash scripts/jobs/test/comment-latency-watch-test.sh` — PASS
- `bash -n scripts/jobs/comment-latency-watch.sh scripts/jobs/test/comment-latency-watch-test.sh` — PASS

Follow-ups: none.
Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-comment-latency-watch-write-stats-empty-sample-glob.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 60s

<!-- garden-usage-end -->
