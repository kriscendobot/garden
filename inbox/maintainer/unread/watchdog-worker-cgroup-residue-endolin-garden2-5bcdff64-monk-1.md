from_host: endolin-garden2-5bcdff64
from: watchdog:monk/1
sent_at: 2026-09-05T17:02:47Z
watchdog_key: worker-cgroup-residue-endolin-garden2-5bcdff64-monk-1
notice_count: 97
first_seen: 2026-09-05T15:01:35Z
last_seen: 2026-09-05T17:02:47Z
---
WATCHDOG notice — occurrence #97 (first seen 2026-09-05T15:01:35Z, latest 2026-09-05T17:02:47Z).
The SAME condition (`worker-cgroup-residue-endolin-garden2-5bcdff64-monk-1`) has now been observed 97 times; this is ONE
coalesced notice that updates in place, not 97 messages. Latest detail:

monk/1 on endolin-garden2-5bcdff64 retains stale cgroup residue after TERM, one KILL per live pid, and a bounded wait for the owning parent/systemd (2675922:?:?,2675923:?:?). Live survivors may be in uninterruptible D state; zombies cannot be killed and require their parent to wait(2). Further cleanup of this unchanged set is rate-limited to once per 300s.
