The `garden-comment-watcher@.service` `TimeoutStopSec=20s` (scripts/systemd/garden-comment-watcher@.service:38) is smaller than the worst-case source-fetch budget inside `scripts/jobs/comment-watcher.sh` (`timeout --signal=TERM --kill-after=10s 30s gh api …`, ~40s when api.github.com is unreachable). When a stop/restart lands mid-fetch during a GitHub outage — as at 09:40:35 (`State 'stop-sigterm' timed out. Killing.` → `status=9/KILL` → `Failed with result 'timeout'`) — the process cannot drain within 20s and gets SIGKILLed, which is the very orphaned-git-in-cgroup failure the unit's KillMode=mixed drain was written to avoid. Align the two budgets: shorten the `gh api` source `timeout` to a value whose worst case (timeout + kill-after) fits inside `TimeoutStopSec` with margin (e.g. `--kill-after=5s 10s`, ≤15s < 20s), rather than raising the stop timeout, so restarts stay fast. Apply the same audit to `garden-ci-watcher@.service` (also `TimeoutStopSec=20s`) if its source uses a comparable or larger fetch budget.

---
claim:
  host: endolinbot2
  gardener: 22
  claimed_at: 2026-07-02T10:25:04Z
