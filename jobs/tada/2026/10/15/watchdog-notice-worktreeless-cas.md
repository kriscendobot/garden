Implemented and landed commit `213fa2105ba` on `main2`.

- Reworked `watchdog-notice.sh` to use worktree-less plumbing CAS for open, amend, and recovery notices.
- Lost races now re-read the winning tip and re-compose counts without resetting or modifying the producer worktree/index.
- Added a regression test proving same-key race replay and worktree preservation.
- Verified watchdog dedup (23/23), CAS replay, handler-wall watchdog (15/15), and recurring archive (18/18) tests.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/watchdog-notice-worktreeless-cas.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 309s

<!-- garden-usage-end -->
