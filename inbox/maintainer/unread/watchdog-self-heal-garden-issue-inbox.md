from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-05T02:22:19Z
watchdog_key: self-heal-garden-issue-inbox
notice_count: 1
first_seen: 2026-11-05T02:22:18Z
last_seen: 2026-11-05T02:22:19Z
---
self-heal: garden-issue-inbox exited rc=1 with no scoped fix. Capture: ede73db786c5c4b833877b2c83a151b2e260004c (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p ede73db786c5c4b833877b2c83a151b2e260004c). Diagnosis: The watcher already has timeout handling for this failure, so I'm not posting a fix job.

**Diagnosis:** The issue-source fetch for `kriscendobot/garden` hit its per-stage timeout (rc=124, "Terminated") at about 02:21. The watcher logged FATAL and exited 1. The same run loaded the 8 maintainers from the allowlist at 02:18:07, and the timeout hit about 3 minutes after that.

This matches a slow or hung GitHub API call, from network latency or a rate-limit or cooldown wait. It doesn't match a code defect. The cursor never advanced, so no maintainer comment was lost. systemd restarts the unit, and the next tick re-polls the same items.

**Next step:** If it keeps happening, look at GitHub primary-quota exhaustion first: the shared `kriscendobot` token is known to be rate-limited. Check whethe
