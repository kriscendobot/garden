from_host: endolin-garden-ece02cb4
from: watchdog:journal-contention-watch
sent_at: 2026-10-19T15:20:44Z
watchdog_key: journal-lock-contention-_home_kris_garden__garden_state_design_pr_gauntlet_audit_journal
notice_count: 3
first_seen: 2026-10-18T06:14:13Z
last_seen: 2026-10-19T15:20:44Z
---
WATCHDOG notice — occurrence #3 (first seen 2026-10-18T06:14:13Z, latest 2026-10-19T15:20:44Z).
The SAME condition (`journal-lock-contention-_home_kris_garden__garden_state_design_pr_gauntlet_audit_journal`) has now been observed 3 times; this is ONE
coalesced notice that updates in place, not 3 messages. Latest detail:

Journal lock contention on endolin-garden-ece02cb4 for /home/kris/garden/.garden-state/design-pr-gauntlet-audit/journal: p95=0.014215s, giveups=1, steals=1 (max 3/window), wait floor=60s.
