Landed commit 360df843722 on main2.

- Eliminated routine daemon reloads from scaler, repo-watcher, and unchanged unit installs.
- Added reload-stable `OnBootSec` anchors to all remaining vulnerable interval timers, including proxy and watchman.
- Added regression coverage for reload suppression, idempotent installs, and timer-anchor auditing.
- Verification passed: enable-services (40), paused-unit (11), timer-fire (7), shell syntax, diff checks, and systemd unit validation.
- Broader tests passed all changed assertions; unrelated existing harness failures remain.

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-garden-daemon-reload-timer-starvation.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 726s

<!-- garden-usage-end -->
