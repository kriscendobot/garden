from_host: endolin-garden-ece02cb4
from: watchdog:journal-worktree-keeper
sent_at: 2026-09-23T23:45:06Z
watchdog_key: journal-worktree-stale-endolin-garden-ece02cb4
notice_count: 2
first_seen: 2026-09-15T16:15:01Z
last_seen: 2026-09-23T23:45:06Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-09-15T16:15:01Z, latest 2026-09-23T23:45:06Z).
The SAME condition (`journal-worktree-stale-endolin-garden-ece02cb4`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

journal worktree /home/kris/garden/journal has been STALE for ~2h (8998s since it last reconciled to origin/journal2; threshold 7200s). The keeper cannot self-resolve it: this tick could not reconcile — diverged; self-heal did not reach origin tip this tick (behind=705). Agents landing in journal/ are reading a LAGGED board and must route around it by hand. Investigate: check this host's connectivity to the journal remote, then 'git -C /home/kris/garden/journal status' and the journal-worktree-keeper log. This is one alert per staleness episode — it will NOT re-page, and clears automatically once the worktree reconciles. (host=endolin-garden-ece02cb4)
