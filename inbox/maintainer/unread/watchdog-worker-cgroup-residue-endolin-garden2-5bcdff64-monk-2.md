from_host: endolin-garden2-5bcdff64
from: watchdog:monk/2
sent_at: 2026-09-05T18:03:15Z
watchdog_key: worker-cgroup-residue-endolin-garden2-5bcdff64-monk-2
notice_count: 156
first_seen: 2026-09-05T15:01:35Z
last_seen: 2026-09-05T18:03:15Z
---
WATCHDOG notice — occurrence #156 (first seen 2026-09-05T15:01:35Z, latest 2026-09-05T18:03:15Z).
The SAME condition (`worker-cgroup-residue-endolin-garden2-5bcdff64-monk-2`) has now been observed 156 times; this is ONE
coalesced notice that updates in place, not 156 messages. Latest detail:

monk/2 on endolin-garden2-5bcdff64 retains stale cgroup residue after TERM, one KILL per live pid, and a bounded wait for the owning parent/systemd (3140296:?:?,3140297:?:?). Live survivors may be in uninterruptible D state; zombies cannot be killed and require their parent to wait(2). Further cleanup of this unchanged set is rate-limited to once per 300s.
