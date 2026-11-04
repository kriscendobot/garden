Implemented and pushed commit `36a2080657e` to `main2`.

- Reaper journal outages now fail open with exit 0, preserve claims, release clone/repository locks, and use the shared 120-second outage cooldown.
- Added a hermetic regression test and CI coverage.
- Verified ShellCheck, syntax, and all six reaper test suites locally.
- GitHub Actions remains red from pre-existing ShellCheck errors in `issue-status-pass.sh`, also present on the preceding main2 run.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-reaper-journal-outage.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 545s

<!-- garden-usage-end -->
