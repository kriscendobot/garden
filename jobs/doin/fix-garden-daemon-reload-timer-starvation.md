---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# fix: daemon-reload storm starves never-fired monotonic timers (garden-proxy, garden-watchman)

Garden-repo fix (main2), leader host endolin-garden2-5bcdff64.

Observed 2026-10-08 by the minion.town arc supervisor: `garden-proxy.timer` (OnActiveSec=5m,
OnUnitActiveSec=5m) did not fire once between its restart at 2026-10-07 22:01Z and 03:49Z,
because there were about 6 `systemctl --user daemon-reload`s a minute (~1047 in 3h), mostly
from `garden-gardener-scaler.service` and also `garden-repo-watcher.service`. Each reload pushed
the never-fired timer's OnActiveSec deadline back by 5 min ("LAST -" in `systemctl --user list-timers`,
and NEXT kept slipping). Result: the proxy, including the minion.town screening/merge pre-pass,
was dead for ~6h, so no screened merge happened. A single manual
`systemctl --user start garden-proxy.service` gave OnUnitActiveSec an anchor, and the timer
has fired on its own since. `garden-watchman.timer` showed the same symptom and was kicked the same way.

Fix both halves:
1. Stop the reload storm: the scaler (and repo-watcher) should daemon-reload only when a unit
   file actually changed, not on every tick. Find the call path, e.g. `unit_ctl daemon-reload` in
   scripts/jobs/{gardener-scaler,repo-watcher,install-units}.sh.
2. Make interval timers robust to reloads even before their first run, e.g. an `OnBootSec=`/`OnCalendar`
   anchor, or have install-units start the service once on (re)install. Audit
   scripts/systemd/*.timer for timers anchored only by OnActiveSec+OnUnitActiveSec.
Add a regression test where the repo has a harness for it, and land on main2 directly (no PR).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-08T03:55:22Z
