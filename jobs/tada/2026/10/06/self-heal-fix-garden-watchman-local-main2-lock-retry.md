Implemented and pushed commit `f8451bd70d1` to `main2`.

- Watchman now retries local branch resolution three times with a one-second delay before failing.
- Added regression coverage simulating two shared-lock timeouts followed by recovery.
- Verified: wedge tests 34/34; main-host tests 53/53; all repository-lock tests passed; `git diff --check` passed.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-watchman-local-main2-lock-retry.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 236s

<!-- garden-usage-end -->
