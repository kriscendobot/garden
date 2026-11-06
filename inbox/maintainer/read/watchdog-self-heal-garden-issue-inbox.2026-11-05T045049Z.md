from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-05T04:50:49Z
watchdog_key: self-heal-garden-issue-inbox
notice_count: 1
first_seen: 2026-11-05T02:22:18Z
last_seen: 2026-11-05T04:50:49Z
---
self-heal: garden-issue-inbox exited rc=1 with no scoped fix. Capture: f85acad03ddd17a9a9cfb1063f815cdf8717c909 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p f85acad03ddd17a9a9cfb1063f815cdf8717c909). Diagnosis: This looks transient, so I'm not posting a fix job.

The captured output is only two lines. The watcher loaded 8 maintainers at 04:46:58. At 04:50:04, about 186 seconds later, it hit `FATAL: issue source failed for kriscendobot/garden (rc=124)`. Exit code 124 is the `timeout` wrapper killing the issue-fetch step, so the `gh` call for the garden repo's issues and comments hung or ran slow. No source stderr was captured, and there's no crash, bad cursor, or missing-file signature.

The likely cause is GitHub API slowness or a rate-limit stall. That matches the known pattern where the shared `kriscendobot` token gets primary-rate-limited (see the memory note on the ci.minion.town runner stall) and clears on the hourly reset. systemd restarts the unit, and the next tick should succeed.

If thi
