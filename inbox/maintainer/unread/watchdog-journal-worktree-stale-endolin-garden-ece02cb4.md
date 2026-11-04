from_host: endolin-garden-ece02cb4
from: watchdog:journal-worktree-keeper
sent_at: 2026-11-04T11:15:39Z
watchdog_key: journal-worktree-stale-endolin-garden-ece02cb4
notice_count: 1
first_seen: 2026-09-15T16:15:01Z
last_seen: 2026-11-04T11:15:39Z
---
journal worktree /home/kris/garden/journal has been STALE for ~2h (7232s since it last reconciled to origin/journal2; threshold 7200s). The keeper cannot self-resolve it: this tick could not reconcile — fetch of origin/journal2 failed (offline?) (behind=unknown). Agents landing in journal/ are reading a LAGGED board and must route around it by hand. Investigate: check this host's connectivity to the journal remote, then 'git -C /home/kris/garden/journal status' and the journal-worktree-keeper log. This is one alert per staleness episode — it will NOT re-page, and clears automatically once the worktree reconciles. (host=endolin-garden-ece02cb4)
