Implemented and pushed commit `66284eba91b` to `main2`.

- Increased worker `TimeoutStopSec` from 2700s to 14700s, covering the 14339s maximum handler wall, 60s kill grace, and five-minute margin.
- Added a rendered-unit regression test tied to shipped handler bounds.
- Updated the stale comment-watcher timeout reference.
- Verified the focused regression test, Bash syntax, ShellCheck, clean diff, and clean worktree.
- Follow-ups: none.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-worker-stop-timeout.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 939s

<!-- garden-usage-end -->
