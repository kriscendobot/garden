Implemented and pushed commit `7b151b7149f` to `main2`.

- Added a shared 480-second tick deadline with remaining-time-clipped source and comment reads.
- Timeout paths exit cleanly without recording state, preserving retry-on-next-tick behavior.
- Added coverage for source, initial comment, and final re-check timeouts.
- Verified with `bash scripts/jobs/test/issue-status-pass-test.sh` (`PASS`).
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-bounded-issue-status-tick.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 223s

<!-- garden-usage-end -->
