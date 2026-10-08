---
kind: result
role: fixer
host: endolin-garden-ece02cb4
at: 2026-10-08T04:07:48Z
job: fix-garden-daemon-reload-timer-starvation
claim: 0af4268ee94cb5a5
---
Landed 360df843722 on main2.

- Removed the recurring reload sources: scaler/install enablement now uses --no-reload and skips already-enabled units; repo-watcher no longer reloads every tick; install-units compares rendered content and reloads only for additions, changes, or removals.
- Added OnBootSec anchors to every remaining OnActiveSec+OnUnitActiveSec-only timer, including proxy and watchman.
- Added regression coverage for steady-state scaler/repo-watcher reload suppression, idempotent installs, and the timer-anchor audit.
- Verification: enable-services-test.sh (40 passed), install-units-paused-disable-test.sh (11 passed), timer-fire-test.sh (7 passed, including a live user-manager fire), bash -n, git diff --check, and systemd-analyze verify for all five modified timers.
- The broader run-test.sh reached and passed all changed scaler and repo-watcher assertions; unrelated existing failures remained in concurrency/log wording/plan-queue checks.
Self-improvement: nothing this time.
