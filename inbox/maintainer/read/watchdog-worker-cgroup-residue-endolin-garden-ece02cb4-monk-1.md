from_host: endolin-garden-ece02cb4
from: watchdog:monk/1
sent_at: 2026-09-05T15:21:19Z
watchdog_key: worker-cgroup-residue-endolin-garden-ece02cb4-monk-1
notice_count: 1
first_seen: 2026-09-05T15:21:15Z
last_seen: 2026-09-05T15:21:19Z
---
monk/1 on endolin-garden-ece02cb4 retains stale cgroup residue after TERM, one KILL per live pid, and a bounded wait for the owning parent/systemd (2957419:?:?,2957420:?:?). Live survivors may be in uninterruptible D state; zombies cannot be killed and require their parent to wait(2). Further cleanup of this unchanged set is rate-limited to once per 300s.
